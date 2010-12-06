package qcrg {
  import dpk.minutes
  import dpk.seconds

  public function parseTime(time:String):Number {
    var parts:Object = /(.*?)(.{1,2})$/.exec(time.replace(/[^0-9]+/g, ''))
    if (parts) {
      return minutes(parts[1] ? parseInt(parts[1]) : 0) +
          seconds(parseInt(parts[2]))
    }
    else
      return NaN
  }
}
