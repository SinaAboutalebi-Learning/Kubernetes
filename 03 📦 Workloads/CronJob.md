A **CronJob** schedules [[Job]]s using cron syntax.

### Uses

- Scheduled backups
- Cleanup tasks
- Nightly reports
- Recurring data processing

### Example schedule

```
* * * * *     # every minute
30 2 * * *     # daily at 02:30
```

CronJob → creates → Job → creates → Pod → completes → Job ends.