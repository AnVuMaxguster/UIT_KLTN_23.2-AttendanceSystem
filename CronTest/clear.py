from crontab import CronTab
cron = CronTab(user='ubuntu')
# cron.remove_all(comment='Add string every 2 mins')
cron.remove_all()
cron.write()