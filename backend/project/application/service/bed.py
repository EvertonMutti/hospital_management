import logging

from sqlalchemy.orm import Session

from project.shared.datasource.bed import BedDataSource
from project.shared.exceptions.exceptions import (BedNotFoundException,
                                                  ServiceUnavailableException)
from project.shared.schemas.bed import BedCreate, BedUpdate

logger = logging.getLogger(__name__)


class BedService:

    def __init__(self, session: Session, bed_data_source: BedDataSource):
        self.db = session
        self.bed_data_source = bed_data_source(session)

    def count_beds_by_status(self):
        try:
            counts = self.bed_data_source.count_beds_by_status()
            logger.info(f"Bed counts by status: {counts}")
            return counts
        except Exception as e:
            logger.error(f"Error fetching bed counts by status: {e}")
            raise ServiceUnavailableException()

    def get_beds_grouped_by_sector(self):
        try:
            beds_grouped = self.bed_data_source.get_beds_grouped_by_sector()
            logger.info(f"Beds grouped by sector: {beds_grouped}")
            return beds_grouped
        except Exception as e:
            logger.error(f"Error fetching beds grouped by sector: {e}")
            raise ServiceUnavailableException()

    def create_bed(self, bed_create: BedCreate):
        try:
            bed = self.bed_data_source.create_bed(bed_create)
            logger.info(f"Created bed: {bed}")
            return bed
        except Exception as e:
            logger.error(f"Error creating bed: {e}")
            raise ServiceUnavailableException()

    def get_bed(self, bed_id: int):
        try:
            bed = self.bed_data_source.get_bed_by_id(bed_id)
            if not bed:
                raise BedNotFoundException(f"Bed with id {bed_id} not found")
            logger.info(f"Fetched bed: {bed}")
            return bed
        except BedNotFoundException:
            raise
        except Exception as e:
            logger.error(f"Error fetching bed: {e}")
            raise ServiceUnavailableException()

    def update_bed(self, bed_id: int, bed_update: BedUpdate):
        try:
            bed = self.get_bed(bed_id)
            bed_updated = self.bed_data_source.update_bed(bed, bed_update)
            logger.info(f"Updated bed: {bed}")
            return bed_updated
        except BedNotFoundException:
            raise
        except Exception as e:
            logger.error(f"Error updating bed: {e}")
            raise

    def delete_bed(self, bed_id: int):
        try:
            bed = self.get_bed(bed_id)
            self.bed_data_source.delete_bed(bed)
            logger.info(f"Deleted bed with id: {bed_id}")
        except BedNotFoundException:
            raise
        except Exception as e:
            logger.error(f"Error deleting bed: {e}")
            raise
