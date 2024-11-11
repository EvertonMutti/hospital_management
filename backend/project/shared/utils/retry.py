import asyncio
import logging
import time
from functools import wraps

logger = logging.getLogger(__name__)


def retry(max_retries=3, delay=0.5):

    def decorator(func):

        @wraps(func)
        def sync_wrapper(*args, **kwargs):
            for attempt in range(max_retries):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    logger.error(
                        f"Attempt {attempt + 1}/{max_retries} failed with error: {e}"
                    )
                    if attempt < max_retries - 1:
                        time.sleep(delay)
                    else:
                        logger.error(
                            "Max retries reached. Raising the exception.")
                        raise

        @wraps(func)
        async def async_wrapper(*args, **kwargs):
            for attempt in range(max_retries):
                try:
                    return await func(*args, **kwargs)
                except Exception as e:
                    logger.error(
                        f"Attempt {attempt + 1}/{max_retries} failed with error: {e}"
                    )
                    if attempt < max_retries - 1:
                        await asyncio.sleep(delay)
                    else:
                        logger.error(
                            "Max retries reached. Raising the exception.")
                        raise

        return async_wrapper if asyncio.iscoroutinefunction(
            func) else sync_wrapper

    return decorator


class RetryBase:  # My Db is a Potato

    def __getattribute__(self, name):
        attr = super().__getattribute__(name)
        if callable(attr) and hasattr(attr,
                                      "__self__") and attr.__self__ is self:
            return retry()(attr)
        return attr
