import 'package:flutter/material.dart';

class TableColumnSpec<T> {
  final String label;
  final String? sortField;
  final bool numeric;
  final Widget Function(T item) build;

  const TableColumnSpec({
    required this.label,
    required this.build,
    this.sortField,
    this.numeric = false,
  });
}

class EntityTable<T> extends StatelessWidget {
  final List<TableColumnSpec<T>> columns;
  final List<T> items;
  final int Function(T item) idOf;
  final Set<int> selected;
  final ValueChanged<int>? onToggleSelect;
  final bool Function(T item)? isDeleted;
  final String? sortField;
  final bool sortAscending;
  final void Function(String field)? onSort;
  final List<Widget> Function(T item)? actions;

  const EntityTable({
    super.key,
    required this.columns,
    required this.items,
    required this.idOf,
    this.selected = const {},
    this.onToggleSelect,
    this.isDeleted,
    this.sortField,
    this.sortAscending = true,
    this.onSort,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final activeSortIndex = columns.indexWhere((c) => c.sortField == sortField);
    final dataColumns = <DataColumn>[
      for (var i = 0; i < columns.length; i++)
        DataColumn(
          label: Text(columns[i].label),
          numeric: columns[i].numeric,
          onSort: columns[i].sortField == null || onSort == null
              ? null
              : (_, __) => onSort!(columns[i].sortField!),
        ),
      if (actions != null) const DataColumn(label: Text('Действия')),
    ];

    return Card(
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          sortColumnIndex: activeSortIndex < 0 ? null : activeSortIndex,
          sortAscending: sortAscending,
          columns: dataColumns,
          rows: items.map((item) {
            final id = idOf(item);
            final deleted = isDeleted?.call(item) ?? false;
            return DataRow(
              selected: selected.contains(id),
              color: deleted
                  ? WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.30),
                    )
                  : null,
              onSelectChanged: onToggleSelect == null
                  ? null
                  : (_) => onToggleSelect!(id),
              cells: [
                for (final column in columns) DataCell(column.build(item)),
                if (actions != null)
                  DataCell(Row(mainAxisSize: MainAxisSize.min, children: actions!(item))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
