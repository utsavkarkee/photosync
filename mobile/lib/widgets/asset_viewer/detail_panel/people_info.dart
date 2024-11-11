import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/extensions/build_context_extensions.dart';
import 'package:mediab/providers/asset_viewer/asset_people.provider.dart';
import 'package:mediab/models/search/search_curated_content.model.dart';
import 'package:mediab/widgets/search/curated_people_row.dart';
import 'package:mediab/widgets/search/person_name_edit_form.dart';
import 'package:mediab/routing/router.dart';
import 'package:mediab/entities/asset.entity.dart';

class PeopleInfo extends ConsumerWidget {
  final Asset asset;
  final EdgeInsets? padding;

  const PeopleInfo({super.key, required this.asset, this.padding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final peopleProvider = ref.watch(assetPeopleNotifierProvider(asset).notifier);
    final people = ref.watch(assetPeopleNotifierProvider(asset)).value?.where((p) => !p.isHidden);
    final double imageSize = math.min(context.width / 3, 150);

    showPersonNameEditModel(
      String personId,
      String personName,
    ) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return PersonNameEditForm(personId: personId, personName: personName);
        },
      ).then((_) {
        // ensure the people list is up-to-date.
        peopleProvider.refresh();
      });
    }

    final curatedPeople = people?.map((p) => SearchCuratedContent(id: p.id, label: p.name)).toList() ?? [];

    return AnimatedCrossFade(
      crossFadeState: (people?.isEmpty ?? true) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 200),
      firstChild: Container(),
      secondChild: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Padding(
              padding: padding ?? EdgeInsets.zero,
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "exif_bottom_sheet_people",
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.textTheme.labelMedium?.color?.withAlpha(200),
                    fontWeight: FontWeight.w600,
                  ),
                ).tr(),
              ),
            ),
            SizedBox(
              height: imageSize,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: CuratedPeopleRow(
                  padding: padding,
                  content: curatedPeople,
                  onTap: (content, index) {
                    context
                        .pushRoute(
                          PersonResultRoute(
                            personId: content.id,
                            personName: content.label,
                          ),
                        )
                        .then((_) => peopleProvider.refresh());
                  },
                  onNameTap: (person, index) => {
                    showPersonNameEditModel(person.id, person.label),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
