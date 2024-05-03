import 'package:docs_sync/screens/app_screens.dart';
import 'package:go_router/go_router.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String? id;
  const DocumentScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Center(
        child: Text(widget.id ?? "Document Screen"),
      ),
    );
  }
}
