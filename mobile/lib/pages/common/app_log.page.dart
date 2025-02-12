import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/extensions/build_context_extensions.dart';
import 'package:mediab/extensions/theme_extensions.dart';
import 'package:mediab/routing/router.dart';
import 'package:mediab/entities/logger_message.entity.dart';
import 'package:mediab/services/immich_logger.service.dart';
import 'package:intl/intl.dart';

@RoutePage()
class AppLogPage extends HookConsumerWidget {
  const AppLogPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final immichLogger = ImmichLogger();
    final logMessages = useState(immichLogger.messages);

    Widget colorStatusIndicator(Color color) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ],
      );
    }

    Widget buildLeadingIcon(LogLevel level) {
      switch (level) {
        case LogLevel.INFO:
          return colorStatusIndicator(context.primaryColor);
        case LogLevel.SEVERE:
          return colorStatusIndicator(Colors.redAccent);

        case LogLevel.WARNING:
          return colorStatusIndicator(Colors.orangeAccent);
        default:
          return colorStatusIndicator(Colors.grey);
      }
    }

    getTileColor(LogLevel level) {
      switch (level) {
        case LogLevel.INFO:
          return Colors.transparent;
        case LogLevel.SEVERE:
          return Colors.redAccent.withOpacity(0.25);
        case LogLevel.WARNING:
          return Colors.orangeAccent.withOpacity(0.25);
        default:
          return context.primaryColor.withOpacity(0.1);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Logs",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        scrolledUnderElevation: 1,
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_outline_rounded,
              color: context.primaryColor,
              semanticLabel: "Clear logs",
              size: 20.0,
            ),
            onPressed: () {
              immichLogger.clearLogs();
              logMessages.value = [];
            },
          ),
          Builder(
            builder: (BuildContext iconContext) {
              return IconButton(
                icon: Icon(
                  Icons.share_rounded,
                  color: context.primaryColor,
                  semanticLabel: "Share logs",
                  size: 20.0,
                ),
                onPressed: () {
                  immichLogger.shareLogs(iconContext);
                },
              );
            },
          ),
        ],
        leading: IconButton(
          onPressed: () {
            context.maybePop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.0,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return const Divider(height: 0);
        },
        itemCount: logMessages.value.length,
        itemBuilder: (context, index) {
          var logMessage = logMessages.value[index];
          return ListTile(
            onTap: () => context.pushRoute(
              AppLogDetailRoute(
                logMessage: logMessage,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            visualDensity: VisualDensity.compact,
            dense: true,
            tileColor: getTileColor(logMessage.level),
            minLeadingWidth: 10,
            title: Text(
              truncateLogMessage(logMessage.message, 4),
              style: TextStyle(
                fontSize: 14.0,
                color: context.colorScheme.onSurface,
                fontFamily: "Inconsolata",
              ),
            ),
            subtitle: Text(
              "at ${DateFormat("HH:mm:ss.SSS").format(logMessage.createdAt)} in ${logMessage.context1}",
              style: TextStyle(
                fontSize: 12.0,
                color: context.colorScheme.onSurfaceSecondary,
              ),
            ),
            leading: buildLeadingIcon(logMessage.level),
          );
        },
      ),
    );
  }

  /// Truncate the log message to a certain number of lines
  /// @param int maxLines - Max number of lines to truncate
  String truncateLogMessage(String message, int maxLines) {
    List<String> messageLines = message.split("\n");
    if (messageLines.length < maxLines) {
      return message;
    }
    return "${messageLines.sublist(0, maxLines).join("\n")} ...";
  }
}
