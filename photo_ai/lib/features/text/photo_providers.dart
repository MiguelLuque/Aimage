//riverpod provider flutter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';

// Un objeto de tipo AppTheme (custom)
// final filterNotifierProvider =
//     StateNotifierProvider<FilterNotifier, NoticeFilter>(
//   (ref) => FilterNotifier(),
// );

// // Controller o Notifier
// class FilterNotifier extends StateNotifier<NoticeFilter> {
//   // STATE = Estado = new AppTheme();
//   FilterNotifier()
//       : super(NoticeFilter(textController: TextEditingController()));

//   void updateValue(String value) {
//     state.textController.text = value;
//     state.textController.selection = TextSelection.fromPosition(
//       TextPosition(offset: state.textController.text.length),
//     );
//     state = state.copyWith(textController: state.textController);
//   }

//   void updateOwnedFilter(bool value) {
//     if (state.owned != value) {
//       state = state.copyWith(owned: value);
//     }
//   }

//   void resetFilters() {
//     state = NoticeFilter(textController: TextEditingController());
//   }
// }

// final noticeListNotifierProvider =
//     StateNotifierProvider<NoticeListNotifier, List<Notice>?>(
//   (ref) => NoticeListNotifier(),
// );

// // Controller o Notifier
// class NoticeListNotifier extends StateNotifier<List<Notice>?> {
//   // STATE = Estado = new AppTheme();
//   NoticeListNotifier() : super(List.empty());

//   // void updateValue(String value) {
//   //   state = state.copyWith(text: value);
//   // }

//   void resetFilters() {
//     state = List.empty();
//   }

//   Future<List<Notice>> fetchNotices(int page, NoticeFilter filter) async {
//     try {
//       final data = await supabase
//           .from('notice')
//           .select<List<Map<String, dynamic>>>()
//           .range(page, page > 0 ? page + 10 : 10);
//       final notices = data.map((notice) => Notice.fromJson(notice)).toList();
//       state = notices;
//       return notices;
//     } catch (e) {
//       throw (Exception('Failed to fetch notices: $e'));
//     }
//   }
// }
