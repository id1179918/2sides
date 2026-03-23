import 'dart:developer';
import 'dart:async';
import 'dart:io';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twosides/constants/env.dart';
import 'package:twosides/models/artist.dart';
import 'package:twosides/models/asset.dart';
import 'package:twosides/models/link.dart';
import 'package:twosides/twosides_provider.dart';
import 'package:twosides/pages/admin_interface_state_model.dart';
import 'package:twosides/constants/colors.dart';
import 'package:twosides/gen/assets.gen.dart';
import 'package:twosides/widgets/page_headers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cross_file/cross_file.dart';
import 'package:collection/collection.dart';

final String imageUrl = Env.imageUrl;

class AddPressKit extends ConsumerStatefulWidget {
  AddPressKit({super.key, required this.artist});
  final Artist artist;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPressKitState();
}

class _AddPressKitState extends ConsumerState<AddPressKit> {
  PlatformFile? _selectedFile;

  @override
  Widget build(BuildContext context) {
    Asset? presskit;

    presskit = widget.artist.assets!
        .firstWhereOrNull((asset) => asset.role == AssetRole.presskit);

    if (presskit != null) {
      return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
        child: Column(children: [
          Text(
            "${widget.artist.name} - Presskit",
          ),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(adminInterfaceViewModelProvider.notifier)
                  .deleteAsset(presskit!.id);
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                backgroundColor: TwoSidesColors.primaryColor,
                minimumSize: const Size(10, 10)),
            child: Text(
              "X",
              style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'signika',
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ]),
      );
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
        child: Column(children: [
          GestureDetector(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                withData: true,
              );
              if (result != null) {
                setState(() => _selectedFile = result.files.first);
              } else {
                // User canceled the picker
              }
            },
            child: Container(
                width: 170,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                  ),
                ),
                child: () {
                  if (_selectedFile == null) {
                    return Icon(Icons.document_scanner);
                  } else if (_selectedFile != null) {
                    return Icon(
                      Icons.check_box,
                      color: Colors.lightGreenAccent,
                    );
                  }
                }()),
          ),
          ElevatedButton(
            onPressed: _selectedFile != null
                ? () async {
                    final XFile x_file = XFile.fromData(
                      _selectedFile!.bytes!,
                      name: _selectedFile!.name,
                    );
                    ref
                        .read(adminInterfaceViewModelProvider.notifier)
                        .uploadAssetArtist(
                            widget.artist.id, x_file, "presskit");
                  }
                : null,
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                backgroundColor: TwoSidesColors.secondaryColor,
                minimumSize: const Size(10, 40)),
            child: Text(
              "Upload",
              style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'signika',
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ]),
      );
    }
  }
}

class AddPictureBox extends ConsumerStatefulWidget {
  AddPictureBox({super.key, required this.artist});
  final Artist artist;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPictureBoxState();
}

class _AddPictureBoxState extends ConsumerState<AddPictureBox> {
  PlatformFile? _selectedFile;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _roleController =
        TextEditingController(text: "gallery");

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
      child: Column(children: [
        GestureDetector(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              withData: true,
            );
            if (result != null) {
              setState(() => _selectedFile = result.files.first);
            } else {
              // User canceled the picker
            }
          },
          child: Container(
              width: 170,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                ),
              ),
              child: () {
                if (_selectedFile == null) {
                  return Icon(Icons.add_a_photo_outlined);
                } else if (_selectedFile != null) {
                  return Image.network(
                    _selectedFile!.path!,
                    fit: BoxFit.contain,
                  );
                }
              }()),
        ),
        SizedBox(
          width: 170,
          height: 50,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            value: _roleController.text!,
            items: ['primary', 'secondary', 'background', 'gallery', 'banner']
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                _roleController.text = value!;
              }
            },
            validator: (value) {
              if (value == null) {
                return 'Please select an option';
              }
              return null;
            },
          ),
        ),
        ElevatedButton(
          onPressed: _selectedFile != null
              ? () async {
                  final XFile x_file = XFile.fromData(
                    _selectedFile!.bytes!,
                    name: _selectedFile!.name,
                  );
                  ref
                      .read(adminInterfaceViewModelProvider.notifier)
                      .uploadAssetArtist(
                          widget.artist.id, x_file, _roleController.text!);
                }
              : null,
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              backgroundColor: TwoSidesColors.secondaryColor,
              minimumSize: const Size(10, 40)),
          child: Text(
            "Upload",
            style: const TextStyle(
                fontSize: 18,
                fontFamily: 'signika',
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
      ]),
    );
  }
}

class PictureBox extends ConsumerStatefulWidget {
  PictureBox({super.key, required this.asset, required this.roleController});
  final Asset asset;
  final TextEditingController roleController;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PictureBoxState();
}

class _PictureBoxState extends ConsumerState<PictureBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
      child: Column(children: [
        SizedBox(
          width: 170,
          height: 170,
          child: Image.network(
            '$imageUrl/asset/${widget.asset.id}',
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                  child: CircularProgressIndicator(
                color: TwoSidesColors.primaryColor,
              ));
            },
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          ),
        ),
        SizedBox(
          width: 170,
          height: 50,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            value: widget.roleController.text!,
            items: ['primary', 'secondary', 'background', 'gallery', 'banner']
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                widget.roleController.text = value!;
              }
            },
            validator: (value) {
              if (value == null) {
                return 'Please select an option';
              }
              return null;
            },
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await ref
                .read(adminInterfaceViewModelProvider.notifier)
                .deleteAsset(widget.asset.id);
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              backgroundColor: TwoSidesColors.primaryColor,
              minimumSize: const Size(10, 10)),
          child: Text(
            "X",
            style: const TextStyle(
                fontSize: 18,
                fontFamily: 'signika',
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ]),
    );
  }
}

class AddLiveBox extends ConsumerStatefulWidget {
  AddLiveBox({super.key, required this.artist});
  final TextEditingController _newLinkController =
      TextEditingController(text: "");
  final TextEditingController _newLinkTypeController =
      TextEditingController(text: "ytb_live");
  final Artist artist;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddLiveBoxState();
}

class _AddLiveBoxState extends ConsumerState<AddLiveBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
      child: Column(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: TextFormField(
            onChanged: (_) {},
            controller: widget._newLinkController,
            decoration: InputDecoration(border: OutlineInputBorder()),
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            if (widget._newLinkController.text != null) {
              //final linkType = stringToLinkType(widget._newLinkTypeController.text);
              await ref
                  .read(adminInterfaceViewModelProvider.notifier)
                  .upsertLinkArtist(
                    "live",
                    widget._newLinkController.text!,
                    "",
                    "artist",
                    widget.artist.id.toString(),
                  );
            }
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              backgroundColor: TwoSidesColors.secondaryColor,
              minimumSize: const Size(10, 40)),
          child: Text(
            "Ajouter",
            style: const TextStyle(
                fontSize: 18,
                fontFamily: 'signika',
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
      ]),
    );
  }
}

class AddReleaseBox extends ConsumerStatefulWidget {
  AddReleaseBox({super.key, required this.artist});
  final TextEditingController _newLinkController =
      TextEditingController(text: "");
  final TextEditingController _newLinkTypeController =
      TextEditingController(text: "ytb_live");
  final Artist artist;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddReleaseBoxState();
}

class _AddReleaseBoxState extends ConsumerState<AddReleaseBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
      child: Column(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: TextFormField(
            onChanged: (_) {},
            controller: widget._newLinkController,
            decoration: InputDecoration(border: OutlineInputBorder()),
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            if (widget._newLinkController.text != null) {
              await ref
                  .read(adminInterfaceViewModelProvider.notifier)
                  .upsertLinkArtist(
                    "release",
                    widget._newLinkController.text!,
                    "",
                    "artist",
                    widget.artist.id.toString(),
                  );
            }
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              backgroundColor: TwoSidesColors.secondaryColor,
              minimumSize: const Size(10, 40)),
          child: Text(
            "Ajouter",
            style: const TextStyle(
                fontSize: 18,
                fontFamily: 'signika',
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
      ]),
    );
  }
}

class AddArtistTile extends ConsumerStatefulWidget {
  const AddArtistTile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddArtistTileState();
}

class _AddArtistTileState extends ConsumerState<AddArtistTile> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController =
        TextEditingController(text: "Nom Artist");
    final TextEditingController _styleController =
        TextEditingController(text: "Electro");
    return Row(children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.17,
        child: TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.1,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: "Style",
              border: OutlineInputBorder(),
            ),
            value: _styleController.text!,
            items: ['Dub', 'Electro']
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                _styleController.text = value!;
              }
            },
            validator: (value) {
              if (value == null) {
                return 'Please select an option';
              }
              return null;
            },
          ),
        ),
      ),
      ElevatedButton(
        onPressed: () async {
          if (_nameController.text != "Nom Artist")
            await ref
                .read(adminInterfaceViewModelProvider.notifier)
                .createArtist(_nameController.text, _styleController.text);
        },
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            backgroundColor: TwoSidesColors.primaryColor,
            minimumSize: const Size(10, 40)),
        child: Text(
          "Ajouter Artist",
          style: const TextStyle(
              fontSize: 18,
              fontFamily: 'signika',
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    ]);
  }
}

class ArtistInfoField extends ConsumerStatefulWidget {
  const ArtistInfoField({super.key, required this.artist});
  final Artist artist;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ArtistInfoFieldState();
}

class _ArtistInfoFieldState extends ConsumerState<ArtistInfoField> {
  List<TextEditingController> setupLinkController() {
    List<TextEditingController> linkController = [];
    for (final linkType in LinkType.values) {
      if (linkType != LinkType.live && linkType != LinkType.release) {
        linkController.add(
            TextEditingController(text: (linkType.toString()).split('.')[1]));
      }
    }
    for (final link in widget.artist.links!) {
      if (link.type == LinkType.live || link.type == LinkType.release) {
        linkController.add(TextEditingController(text: link.url));
      } else {
        final index = linkController.indexWhere((controller) =>
            controller.text == (link.type.toString()).split('.')[1]);
        if (index != -1) {
          linkController[index].text = link.url;
        }
      }
    }
    return linkController;
  }

  @override
  Widget build(BuildContext context) {
    final adminInterfaceViewState = ref.watch(adminInterfaceViewModelProvider);
    final String _originalName = widget.artist.name;
    final String _originalLocation = widget.artist.location ?? "";
    final String _originalDescription = widget.artist.description ?? "";
    final String _originalStyle = widget.artist.style ?? "";
    final String _originalLabel = widget.artist.label ?? "";
    final int _originalPosition =
        widget.artist.position == null ? 99 : widget.artist.position!;
    final TextEditingController _nameController =
        TextEditingController(text: widget.artist.name);
    final TextEditingController _locationController =
        TextEditingController(text: widget.artist.location ?? "");
    final TextEditingController _descriptionController =
        TextEditingController(text: widget.artist.description ?? "");
    final TextEditingController _styleController =
        TextEditingController(text: widget.artist.style ?? "Electro");
    final List<TextEditingController> _pictureRoleControllers = widget
        .artist.assets!
        .map((asset) =>
            TextEditingController(text: assetRoleToString(asset.role)))
        .toList();
    final TextEditingController _labelController =
        TextEditingController(text: widget.artist.label ?? "");
    final TextEditingController _positionController = TextEditingController(
        text: widget.artist.position == null
            ? "99"
            : widget.artist.position!.toString());
    final List<TextEditingController> _linkControllers = setupLinkController();
    //LinkType.values.map((linkType) => TextEditingController(text: (linkType.toString()).split('.')[1])).toList();
    List<bool> linkHaveChanged =
        List.filled(_linkControllers.length, false, growable: false);
    bool _hasLinksChanged = false;
    //if (widget.artist.links != null) {
    //  for (final controller in _linkControllers) {
    //    for (final link in widget.artist.links!) {
    //      if (controller.text == (link.type.toString()).split('.')[1]) {
    //        controller.text = link.url;
    //      }
    //    }
    //  }
    //}

    //widget.artist.links!.map((link) => TextEditingController(text: assetRoleToString(asset.role))).toList();

    bool hasValuesChanged() {
      if (_originalName != _nameController.text) {
        return true;
      }
      if (_originalLocation != _locationController.text) {
        return true;
      }
      if (_originalDescription != _descriptionController.text) {
        return true;
      }
      if (_originalStyle != _styleController.text) {
        return true;
      }
      if (_originalLabel != _labelController.text) {
        return true;
      }
      if (_originalPosition.toString() != _positionController.text) {
        return true;
      }
      return false;
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text("Nom d'artist"),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.17,
            child: TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ),
      ]),
      Row(children: [
        Text("Position"),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.17,
            child: TextFormField(
              controller: _positionController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ),
      ]),
      Row(children: [
        Text("Label"),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.17,
            child: TextFormField(
              controller: _labelController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ),
      ]),
      Row(children: [
        Text("Localisation"),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.17,
            child: TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ),
      ]),
      Row(children: [
        Text("Description"),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextFormField(
              controller: _descriptionController,
              maxLines: 10,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ),
      ]),
      Row(children: [
        Text("Style"),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: _styleController.text!,
                border: OutlineInputBorder(),
              ),
              value: _styleController.text!,
              items: ['Dub', 'Electro']
                  .map((option) => DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  _styleController.text = value!;
                }
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select an option';
                }
                return null;
              },
            ),
          ),
        ),
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Liens"),
        Wrap(
          spacing: 4, // horizontal spacing
          runSpacing: 16, // vertical spacing
          children: [
            for (final (index, linkType) in LinkType.values.indexed)
              if (linkType != LinkType.live && linkType != LinkType.release)
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                  child: Row(children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.20,
                      child: TextFormField(
                        onChanged: (_) {
                          linkHaveChanged[index] = true;
                        },
                        controller: _linkControllers[index],
                        decoration: InputDecoration(
                            labelText: (linkType.toString()).split('.')[1],
                            border: OutlineInputBorder()),
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (widget.artist.links != null) {
                          final int linkIndex = widget.artist.links!
                              .indexWhere((link) => link.type == linkType);
                          if (widget.artist.links![linkIndex].url !=
                              linkType.toString().split('.')[1]) {
                            await ref
                                .read(adminInterfaceViewModelProvider.notifier)
                                .deleteLink(widget.artist.links![linkIndex].id);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          backgroundColor: TwoSidesColors.primaryColor,
                          minimumSize: const Size(10, 10)),
                      child: Text(
                        "X",
                        style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'signika',
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                ),
          ],
        ),
      ]),
      Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Photos"),
          SizedBox(
            height: 300,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              for (final (index, asset) in widget.artist.assets!.indexed)
                if (asset.role != AssetRole.presskit)
                  PictureBox(
                      asset: asset,
                      roleController: _pictureRoleControllers[index]),
              AddPictureBox(artist: widget.artist),
            ]),
          ),
        ]),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Live/Podcast"),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: SizedBox(
              height: 110,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                for (final link in widget.artist.links!)
                  if (link.type == LinkType.live)
                    Builder(
                      builder: (context) {
                        int index = _linkControllers.indexWhere(
                            (controller) => controller.text == link.url);
                        if (index != -1) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 5),
                            child: Column(children: [
                              Row(children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: TextFormField(
                                    onChanged: (_) {
                                      linkHaveChanged[index] = true;
                                    },
                                    controller: _linkControllers[index],
                                    decoration: InputDecoration(
                                        labelText: "Live",
                                        border: OutlineInputBorder()),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (widget.artist.links != null) {
                                      final int linkIndex = widget.artist.links!
                                          .indexWhere((link) =>
                                              link.url ==
                                              _linkControllers[index].text);
                                      await ref
                                          .read(adminInterfaceViewModelProvider
                                              .notifier)
                                          .deleteLink(widget
                                              .artist.links![linkIndex].id);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      backgroundColor:
                                          TwoSidesColors.primaryColor,
                                      minimumSize: const Size(10, 10)),
                                  child: Text(
                                    "X",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'signika',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ]),
                            ]),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                AddLiveBox(artist: widget.artist),
              ]),
            ),
          )
        ]),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Release"),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: SizedBox(
              height: 110,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                for (final link in widget.artist.links!)
                  if (link.type == LinkType.release)
                    Builder(
                      builder: (context) {
                        int index = _linkControllers.indexWhere(
                            (controller) => controller.text == link.url);
                        if (index != -1) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 5),
                            child: Column(children: [
                              Row(children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: TextFormField(
                                    onChanged: (_) {
                                      linkHaveChanged[index] = true;
                                    },
                                    controller: _linkControllers[index],
                                    decoration: InputDecoration(
                                        labelText: "Release",
                                        border: OutlineInputBorder()),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (widget.artist.links != null) {
                                      final int linkIndex = widget.artist.links!
                                          .indexWhere((link) =>
                                              link.url ==
                                              _linkControllers[index].text);
                                      await ref
                                          .read(adminInterfaceViewModelProvider
                                              .notifier)
                                          .deleteLink(widget
                                              .artist.links![linkIndex].id);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      backgroundColor:
                                          TwoSidesColors.primaryColor,
                                      minimumSize: const Size(10, 10)),
                                  child: Text(
                                    "X",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'signika',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ]),
                            ]),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                AddReleaseBox(artist: widget.artist),
              ]),
            ),
          )
        ]),
      ),
      Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: AddPressKit(
            artist: widget.artist,
          )),
      Row(children: [
        ElevatedButton(
          onPressed: () async {
            if (hasValuesChanged()) {
              Artist updatedArtist = Artist(
                id: widget.artist.id,
                name: _nameController.text,
                location: _locationController.text,
                description: _descriptionController.text,
                label: _labelController.text,
                position: int.tryParse(_positionController.text) ?? 99,
              );
              await ref
                  .read(adminInterfaceViewModelProvider.notifier)
                  .updateArtist(updatedArtist);
            }
            for (final (index, linkState) in linkHaveChanged.indexed) {
              if (linkState == true) {
                await ref
                    .read(adminInterfaceViewModelProvider.notifier)
                    .upsertLinkArtist(
                      LinkType.values[index].toString().split('.')[1],
                      _linkControllers[index].text,
                      "",
                      "artist",
                      widget.artist.id.toString(),
                    );
              }
            }
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              backgroundColor: TwoSidesColors.secondaryColor,
              minimumSize: const Size(10, 60)),
          child: Text(
            "Sauvegarder",
            style: const TextStyle(
                fontSize: 18,
                fontFamily: 'signika',
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await ref
                .read(adminInterfaceViewModelProvider.notifier)
                .deleteArtist(widget.artist.id);
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              backgroundColor: TwoSidesColors.primaryColor,
              minimumSize: const Size(10, 60)),
          child: Text(
            "Supprimer",
            style: const TextStyle(
                fontSize: 18,
                fontFamily: 'signika',
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ])
    ]);
  }
}

class ArtistInfoTile extends StatefulWidget {
  ArtistInfoTile({super.key, required this.artist});
  final Artist artist;

  @override
  State<ArtistInfoTile> createState() => _ArtistInfoTileState();
}

class _ArtistInfoTileState extends State<ArtistInfoTile> {
  bool _isOpened = false;
  String _assetId = "";

  @override
  Widget build(BuildContext context) {
    if (widget.artist.assets != null) {
      _assetId = widget.artist.assets!
          .indexWhere((asset) => asset.role == AssetRole.primary)
          .toString();
    }

    return Builder(builder: (context) {
      if (_isOpened) {
        return Container(
          height: MediaQuery.of(context).size.height * 2.5,
          alignment: Alignment.topLeft,
          color: widget.artist.style == "Dub"
              ? TwoSidesColors.primaryColor.withOpacity(0.1)
              : TwoSidesColors.secondaryColor.withOpacity(0.2),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              GestureDetector(
                onTap: () => setState(() => _isOpened = !_isOpened),
                child: Icon(Icons.arrow_circle_up),
              ),
              Text(
                widget.artist.name,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ]),
            Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: ArtistInfoField(artist: widget.artist)),
          ]),
        );
      } else {
        return Container(
            height: 50,
            color: widget.artist.style == "Dub"
                ? TwoSidesColors.primaryColor.withOpacity(0.1)
                : TwoSidesColors.secondaryColor.withOpacity(0.2),
            child: Row(children: [
              GestureDetector(
                onTap: () => setState(() => _isOpened = !_isOpened),
                child: Icon(Icons.arrow_circle_down),
              ),
              Text(
                widget.artist.name,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ]));
      }
    });
  }
}

class AdminInterfaceArtist extends ConsumerWidget {
  AdminInterfaceArtist({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminInterfaceViewState = ref.watch(adminInterfaceViewModelProvider);

    return adminInterfaceViewState.artists.when(
      data: (_) {
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: adminInterfaceViewState.artists.value!.length,
                itemBuilder: (context, index) {
                  return ArtistInfoTile(
                    artist: adminInterfaceViewState.artists.value![index],
                  );
                },
                separatorBuilder: (_, __) => const Divider(),
              ),
            ),
            AddArtistTile(),
          ],
        );
      },
      error: (error, stacktrace) {
        return Column(
            children: [Text(error.toString()), Text(stacktrace.toString())]);
      },
      loading: () => Container(
        color: Colors.black.withOpacity(0.6),
        child: Center(
          child: CircularProgressIndicator(
            color: TwoSidesColors.primaryColor,
          ),
        ),
      ),
    );
  }
}

class AdminInterfaceEvent extends ConsumerWidget {
  AdminInterfaceEvent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminInterfaceViewState = ref.watch(adminInterfaceViewModelProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          // A fixed-height child.
          color: const Color(0xffeeee00), // Yellow
          height: 120.0,
          alignment: Alignment.center,
          child: const Text('Réglages Events'),
        ),
      ],
    );
  }
}

class AdminInterfaceAbout extends ConsumerWidget {
  AdminInterfaceAbout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminInterfaceViewState = ref.watch(adminInterfaceViewModelProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          // A fixed-height child.
          color: const Color(0xffeeee00), // Yellow
          height: 120.0,
          alignment: Alignment.center,
          child: const Text('Réglages About'),
        ),
      ],
    );
  }
}

class AdminInterface extends ConsumerWidget {
  AdminInterface({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminInterfaceViewState = ref.watch(adminInterfaceViewModelProvider);

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Builder(builder: (context) {
              switch (adminInterfaceViewState.pageType.value) {
                case AdminInterfacePageTypes.artist:
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 1.2,
                    child: AdminInterfaceArtist(),
                  );
                  break;
                case AdminInterfacePageTypes.event:
                  return AdminInterfaceEvent();
                  break;
                case AdminInterfacePageTypes.about:
                  return AdminInterfaceAbout();
                  break;
                default:
                  return Container();
                  break;
              }
            })),
      );
    });
  }
}

class AdminInterfaceMenu extends ConsumerWidget {
  AdminInterfaceMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminInterfaceViewState = ref.watch(adminInterfaceViewModelProvider);

    ref.listen<AdminInterfaceViewState>(
      adminInterfaceViewModelProvider,
      (_, currentState) {
        currentState.admin.whenOrNull(
          skipError: true,
          data: (admin) {
            if (admin != null && admin.status == "logout") {
              Navigator.pushNamed(context, "/");
            } else if (admin != null && admin.status == "success") {
              html.window.location.reload();
            }
          },
          error: (error, _) {
            log(error.toString());
          },
        );
      },
    );

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        TextButton(
          child: Text(
            "Artists",
            style: TextStyle(
                fontSize: 25,
                color: adminInterfaceViewState.pageType.value ==
                        AdminInterfacePageTypes.artist
                    ? TwoSidesColors.primaryColor
                    : TwoSidesColors.textColor),
            //fontWeight: adminInterfaceViewState.pageType.value == AdminInterfacePageTypes.artist ? FontWeight.bold : FontWeight.normal,
          ),
          onPressed: () {
            ref
                .read(adminInterfaceViewModelProvider.notifier)
                .changeInterfacePage(AdminInterfacePageTypes.artist);
          },
        ),
        TextButton(
          child: Text(
            "Events",
            style: TextStyle(
                fontSize: 25,
                color: adminInterfaceViewState.pageType.value ==
                        AdminInterfacePageTypes.event
                    ? TwoSidesColors.primaryColor
                    : TwoSidesColors.textColor),
            //adminInterfaceViewState.pageType.value == AdminInterfacePageTypes.event ? FontWeight.bold : FontWeight.normal,
          ),
          onPressed: () {
            ref
                .read(adminInterfaceViewModelProvider.notifier)
                .changeInterfacePage(AdminInterfacePageTypes.event);
          },
        ),
        TextButton(
          child: Text(
            "About",
            style: TextStyle(
                fontSize: 25,
                color: adminInterfaceViewState.pageType.value ==
                        AdminInterfacePageTypes.about
                    ? TwoSidesColors.primaryColor
                    : TwoSidesColors.textColor),
            //adminInterfaceViewState.pageType.value == AdminInterfacePageTypes.about ? FontWeight.bold : FontWeight.normal,
          ),
          onPressed: () {
            ref
                .read(adminInterfaceViewModelProvider.notifier)
                .changeInterfacePage(AdminInterfacePageTypes.about);
          },
        ),
        ElevatedButton(
          onPressed: () async {
            ref.read(adminInterfaceViewModelProvider.notifier).logout();
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              backgroundColor: TwoSidesColors.primaryColor,
              minimumSize: const Size(10, 60)),
          child: Text(
            "Deconnexion",
            style: const TextStyle(
                fontSize: 18,
                fontFamily: 'signika',
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ]),
    );
  }
}

class AdminInterfacePage extends StatelessWidget {
  AdminInterfacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      AdminInterfaceMenu(),
      SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: AdminInterface()),
    ]));
  }
}
