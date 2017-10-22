Sub MoveRows()
Dim iRow As Long, iLastRow As Long, iColumn As Long
iLastRow = ActiveSheet.Range("A65536").End(xlUp).Row
For iRow = iLastRow To 2 Step -1
  For iColumn = 6 To 2 Step -1
  If Cells(iRow, iColumn).Value <> "" Then
  Rows(iRow + 1).EntireRow.Insert
  Cells(iRow + 1, 1).Value = Cells(iRow, 1).Value
  Cells(iRow + 1, 2).Value = Cells(1, iColumn).Value
  Cells(iRow + 1, 3).Value = Cells(iRow, iColumn).Value
  End If
  Next iColumn
  Rows(iRow).EntireRow.Delete
  Next iRow
End Sub
