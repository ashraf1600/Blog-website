from whitenoise.storage import CompressedStaticFilesStorage
import os
import logging

logger = logging.getLogger(__name__)


class ForgivingWhiteNoiseStorage(CompressedStaticFilesStorage):
    """
    Custom WhiteNoise storage that doesn't fail on missing files
    """
    
    def post_process(self, paths, dry_run=False, **options):
        """
        Process static files but skip files that don't exist
        """
        if dry_run:
            return []
        
        # Filter out non-existent files before processing
        existing_paths = {}
        for path, (storage, prefixed_path) in paths.items():
            try:
                full_path = self.path(path)
                if os.path.exists(full_path):
                    existing_paths[path] = (storage, prefixed_path)
                else:
                    logger.warning(f"Skipping missing file: {path}")
            except Exception as e:
                logger.warning(f"Error checking file {path}: {e}")
                continue
        
        # Process only existing files
        try:
            yield from super().post_process(existing_paths, dry_run, **options)
        except Exception as e:
            logger.error(f"Error during post-processing: {e}")
            # Return empty generator on error to prevent build failure
            return
            yield  # Make this a generator