import 'package:demo_plugin_example/data/models/vietmap_autocomplete_model.dart';
import 'package:demo_plugin_example/domain/repository/vietmap_api_repositories.dart';
import 'package:demo_plugin_example/domain/usecase/search_address_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class FloatingSearchBar extends StatelessWidget {
  final Function(VietmapAutocompleteModel) onSearchItemClick;
  final FocusNode focusNode;
  const FloatingSearchBar(
      {super.key, required this.onSearchItemClick, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width - 20,
      height: 50,
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
            focusNode: focusNode,
            autofocus: false,
            style: const TextStyle(fontSize: 17),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                hintText: 'Nhập địa chỉ...',
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30)),
                border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30)))),
        suggestionsCallback: (pattern) async {
          if (pattern.isNotEmpty) {
            var data = await SearchAddressUseCase(VietmapApiRepositories())
                .call(pattern);
            var res = <VietmapAutocompleteModel>[];
            data.fold((l) {
              res = [];
            }, (r) {
              res = r;
            });
            return res;
          }
          return <VietmapAutocompleteModel>[];
        },
        itemBuilder: (context, VietmapAutocompleteModel suggestion) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSearchItemClick(suggestion),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade100,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4285F4).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFF4285F4),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            suggestion.name ?? '',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF202124),
                              letterSpacing: -0.2,
                              height: 1.4,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            suggestion.address ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF5F6368),
                              height: 1.4,
                              letterSpacing: -0.1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.north_west,
                      size: 16,
                      color: Color(0xFF9AA0A6),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        noItemsFoundBuilder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 48,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Không tìm thấy địa chỉ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF202124),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Vui lòng thử lại với từ khóa khác',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        },
        onSuggestionSelected: onSearchItemClick,
      ),
    );
  }
}
