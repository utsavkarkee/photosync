import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/extensions/response_extensions.dart';
import 'package:mediab/entities/asset.entity.dart';
import 'package:mediab/providers/api.provider.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'api.service.dart';

final shareServiceProvider = Provider((ref) => ShareService(ref.watch(apiServiceProvider)));

class ShareService {
  final ApiService _apiService;
  final Logger _log = Logger("ShareService");

  ShareService(this._apiService);

  Future<bool> shareAsset(Asset asset, BuildContext context) async {
    return await shareAssets([asset], context);
  }

  Future<bool> shareAssets(List<Asset> assets, BuildContext context) async {
    try {
      final downloadedXFiles = <XFile>[];

      for (var asset in assets) {
        if (asset.isLocal) {
          // Prefer local assets to share
          File? f = await asset.local!.file;
          downloadedXFiles.add(XFile(f!.path));
        } else if (asset.isRemote) {
          // Download remote asset otherwise
          final tempDir = await getTemporaryDirectory();
          final fileName = asset.fileName;
          final tempFile = await File('${tempDir.path}/$fileName').create();
          final res = await _apiService.assetsApi.downloadAssetWithHttpInfo(asset.remoteId!);

          if (res.statusCode != 200) {
            _log.severe(
              "Asset download for ${asset.fileName} failed",
              res.toLoggerString(),
            );
            continue;
          }

          tempFile.writeAsBytesSync(res.bodyBytes);
          downloadedXFiles.add(XFile(tempFile.path));
        }
      }

      if (downloadedXFiles.isEmpty) {
        _log.warning("No asset can be retrieved for share");
        return false;
      }

      if (downloadedXFiles.length != assets.length) {
        _log.warning(
          "Partial share - Requested: ${assets.length}, Sharing: ${downloadedXFiles.length}",
        );
      }

      final box = context.findRenderObject() as RenderBox?;
      Share.shareXFiles(
        downloadedXFiles,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
      return true;
    } catch (error) {
      _log.severe("Share failed", error);
    }
    return false;
  }
}
