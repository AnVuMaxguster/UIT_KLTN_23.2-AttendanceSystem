from crontab import CronTab
cron = CronTab(user='ubuntu')

job1 = cron.new(command='date >> /home/ubuntu/CronTest/test.txt', comment='Add date every min')
job1.minute.every(1)
if job1.is_valid():
    comment1 = job1.comment
    print(f"Job {comment1} scheduled")

job2 = cron.new(command='echo "2 mins passed" >> /home/ubuntu/CronTest/test.txt', comment='Add string every 2 mins')
job2.minute.every(2)
if job2.is_valid():
    comment2 = job2.comment
    print(f"Job {comment2} scheduled ")

cron.write()

# job.setall('2 10 * * *')

# job2.enable(False)
# cron.write()