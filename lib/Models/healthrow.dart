class HealthRow
{
  final String date_sample;
  final String weight;
  final String h2o;
  final String fat;
  final String muscles;
  final String bones;
  final String bmi;

  const HealthRow(this.date_sample,this.weight,this.h2o,this.fat,this.muscles,this.bones,this.bmi);
  String toCsv()
  {
    return '$date_sample,$weight,$h2o,$fat,$muscles,$bones,$bmi';
  }
  
}