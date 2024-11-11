import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mediab/extensions/asyncvalue_extensions.dart';
import 'package:mediab/models/search/search_curated_content.model.dart';
import 'package:mediab/providers/search/people.provider.dart';
import 'package:mediab/widgets/search/explore_grid.dart';

@RoutePage()
class AllPeoplePage extends HookConsumerWidget {
  const AllPeoplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curatedPeople = ref.watch(getAllPeopleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'all_people_page_title',
        ).tr(),
        leading: IconButton(
          onPressed: () => context.maybePop(),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: curatedPeople.widgetWhen(
        onData: (people) => ExploreGrid(
          isPeople: true,
          curatedContent: people.map((e) => SearchCuratedContent(label: e.name, id: e.id)).toList(),
        ),
      ),
    );
  }
}
