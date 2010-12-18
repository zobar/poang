package dpk {
  import mx.controls.listClasses.BaseListData
  import mx.controls.listClasses.IDropInListItemRenderer
  import mx.controls.listClasses.IListItemRenderer
  import spark.components.CheckBox

  public class CheckBoxListItemRenderer extends CheckBox
      implements IDropInListItemRenderer, IListItemRenderer {
    [Bindable]
    public function get data():Object {
      return _data
    }
    public function set data(value:Object):void {
      _data = value
      dataChanged = true
      invalidateProperties()
    }
    protected var _data:Object

    protected var dataChanged:Boolean

    [Bindable]
    public function get listData():BaseListData {
      return _listData
    }
    public function set listData(value:BaseListData):void {
      _listData = value
      dataChanged = true
      invalidateProperties()
    }
    protected var _listData:BaseListData

    override public function validateProperties():void {
      if (dataChanged && listData && 'dataField' in listData) {
        dataChanged = false
        selected = data && data[listData['dataField']]
      }
      super.validateProperties()
    }
  }
}
