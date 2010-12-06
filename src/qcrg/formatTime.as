package qcrg {
  public function formatTime(value:int, parseable:Boolean=false):String {
    if (parseable) {
      return int(value / 60000) + ':' + int((value / 10000) % 6) +
          int((value / 1000) % 10)
    }
    else {
      var hours:int = value / 3600000
      if (hours) {
        return hours + ':' + int((value / 600000) % 6) +
            int((value / 60000) % 10)
      }
      else {
        var minutes:int = (value / 60000) % 60
        var seconds:String = ':' + int((value / 10000) % 6) +
            int((value / 1000) % 10)
        if (minutes)
          return minutes + seconds
        else {
          var tenths:int = (value / 100) % 10
          return seconds + '.' + tenths
        }
      }
    }
  }
}
