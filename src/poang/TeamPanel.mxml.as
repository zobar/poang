import dpk.CheckBoxListItemRenderer
import mx.controls.listClasses.IListItemRenderer
import mx.events.DataGridEvent

[Bindable] public var team:Team

protected function onEditTeamClick(event:MouseEvent):void {
  Poang.app.bout.editTeam(team)
}

protected function onPeopleItemEditBeginning(event:DataGridEvent):void {
  var dataGrid:DataGrid = DataGrid(event.currentTarget)
  var column:DataGridColumn = dataGrid.columns[event.columnIndex]
  if (column == jammerColumn) {
    var checkBox:CheckBoxListItemRenderer =
        CheckBoxListItemRenderer(event.itemRenderer)
    if (checkBox) {
      if (checkBox.selected)
        team.jammer = null
      else
        team.jammer = Person(dataGrid.selectedItem)
    }
  }
  event.preventDefault()
}
