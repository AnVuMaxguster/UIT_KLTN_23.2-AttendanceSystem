import logging
import logging.handlers
import os

class clog:
    counter = 0
    message = {}
    def __init__(self, name, path = None):
        curentFilePath = os.path.abspath(__file__)
        absolute_path = os.path.abspath(os.path.join(os.path.dirname(curentFilePath), path))
        self.name = name
        self.path = absolute_path


    def setup_logger(self):
        logger = logging.getLogger(self.name)
        logger.propagate = False
        if self.path != None:
            file_handler = logging.handlers.RotatingFileHandler(
                self.path,
                maxBytes=25000000,
                backupCount=5,
            )
            logger.addHandler(file_handler)

        formatter = logging.Formatter("%(asctime)s %(levelname)s %(message)s")
        file_handler.setFormatter(formatter)
        logger.setLevel(level=logging.DEBUG)
        return logger
