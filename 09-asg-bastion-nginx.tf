# Create sns topic for all the auto scaling groups
resource "aws_sns_topic" "punltd-sns" {
name = "Default_CloudWatch_Alarms_Topic"
}