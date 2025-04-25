import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../engine/layer_manager.dart';

class LayerUI extends ConsumerStatefulWidget {
  const LayerUI({Key? key}) : super(key: key);

  @override
  ConsumerState<LayerUI> createState() => _LayerUIState();
}

class _LayerUIState extends ConsumerState<LayerUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.grey[900],
      child: Column(
        children: [
          _buildLayerHeader(),
          Expanded(child: _buildLayerList()),
          _buildLayerControls(),
        ],
      ),
    );
  }

  Widget _buildLayerHeader() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: const Text(
        'Layers',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLayerList() {
    // Implement layer list with drag-and-drop support
    return ListView();
  }

  Widget _buildLayerControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            // Add new layer
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            // Delete selected layer
          },
        ),
        IconButton(
          icon: const Icon(Icons.visibility),
          onPressed: () {
            // Toggle layer visibility
          },
        ),
      ],
    );
  }
}