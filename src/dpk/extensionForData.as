package dpk {
  import flash.utils.ByteArray

  public function extensionForData(data:ByteArray):String {
    switch (data[0]) {
      case 0x43:
      case 0x46:
        return '.swf'
      case 0x47:
        return '.gif'
      case 0x89:
        return '.png'
      case 0xff:
        return '.jpg'
    }
    return ''
  }
}
