import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ToolType {
  brush,
  eraser,
  selection,
  transform,
  text,
  shape,
  eyedropper,
}

class ToolsUI extends ConsumerStatefulWidget {
  const ToolsUI({Key? key}) : super(key: key);

  @override
  ConsumerState<ToolsUI> createState() => _ToolsUIState();
}

class _ToolsUIState extends ConsumerState<ToolsUI> {
  ToolType _selectedTool = ToolType.brush;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      color: Colors.grey[900],
      child: Column(
        children: [
          _buildToolButton(ToolType.brush, Icons.brush),
          _buildToolButton(ToolType.eraser, Icons.auto_fix_high),
          _buildToolButton(ToolType.selection, Icons.select_all),
          _buildToolButton(ToolType.transform, Icons.transform),
          _buildToolButton(ToolType.text, Icons.text_fields),
          _buildToolButton(ToolType.shape, Icons.shape_line),
          _buildToolButton(ToolType.eyedropper, Icons.colorize),
        ],
      ),
    );
  }

  Widget _buildToolButton(ToolType tool, IconData icon) {
    final isSelected = _selectedTool == tool;
    
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey,
        ),
        onPressed: () {
          setState(() => _selectedTool = tool);
          // Notify tool selection change
        },
      ),
    );
  }
}