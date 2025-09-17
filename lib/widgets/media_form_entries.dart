import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/constants.dart';

/// A collection of media-related form entry widgets
class MediaFormEntries {
  /// Single picture form field
  static Widget pictureFormEntry({
    String title = 'Picture',
    String subTitle = 'Upload a picture',
    String? defaultValue,
    File? selectedImage,
    Uint8List? selectedImageBytes,
    required VoidCallback onPickImage,
    required VoidCallback onRemoveImage,
    bool enabled = true,
    required BuildContext context,
  }) {
    bool hasImage =
        (defaultValue != null && defaultValue.isNotEmpty) ||
        selectedImage != null ||
        selectedImageBytes != null;

    return _FormEntryWrapper.formEntry(
      title: title,
      subTitle: subTitle,
      context: context,
      inputWidget: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            // Image Display Section
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: hasImage
                  ? CircleAvatar(
                      radius: 60,
                      backgroundImage: kIsWeb && selectedImageBytes != null
                          ? MemoryImage(selectedImageBytes)
                          : selectedImage != null
                          ? FileImage(selectedImage)
                          : CachedNetworkImageProvider(defaultValue!),
                    )
                  : CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[100],
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                    ),
            ),
            const SizedBox(height: 24),

            // Action Buttons Section
            Row(
              children: [
                // Select/Change Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: enabled ? onPickImage : null,
                    icon: Icon(
                      hasImage ? Icons.edit : Icons.add_a_photo,
                      size: 20,
                    ),
                    label: Text(
                      hasImage ? 'Change Photo' : 'Add Photo',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryActiveColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      shadowColor: primaryActiveColor.withOpacity(0.3),
                    ),
                  ),
                ),

                if (hasImage) ...[
                  const SizedBox(width: 12),
                  // Remove Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: enabled ? onRemoveImage : null,
                      icon: Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: Colors.red[600],
                      ),
                      label: Text(
                        'Remove',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.red[600],
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.red[300]!),
                      ),
                    ),
                  ),
                ],
              ],
            ),

            // Helper Text
            if (!hasImage) ...[
              const SizedBox(height: 12),
              Text(
                'Upload a photo to personalize your profile',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Multi-photo form field
  static Widget multiPhotoFormEntry({
    String title = 'Photos',
    String subTitle = 'Upload multiple photos',
    List<File>? selectedImages,
    List<XFile>? webSelectedImages,
    Function(List<File>)? onImagesSelected,
    Function(List<XFile>)? onXFilesSelected,
    int maxImages = 5,
    bool enabled = true,
    GlobalKey<FormState>? formKey,
    VoidCallback? onModified,
    required BuildContext context,
  }) {
    selectedImages ??= [];
    webSelectedImages ??= [];

    return _FormEntryWrapper.formEntry(
      title: title,
      subTitle: subTitle,
      context: context,
      inputWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display selected images
          if ((selectedImages.isNotEmpty) ||
              (kIsWeb && webSelectedImages.isNotEmpty))
            Container(
              height: 140,
              margin: const EdgeInsets.only(bottom: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: kIsWeb
                    ? webSelectedImages.length
                    : selectedImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: 110,
                    height: 110,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: kIsWeb
                                ? FutureBuilder<Uint8List>(
                                    future: webSelectedImages![index]
                                        .readAsBytes(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Image.memory(
                                          snapshot.data!,
                                          width: 110,
                                          height: 110,
                                          fit: BoxFit.cover,
                                        );
                                      }
                                      return Container(
                                        width: 110,
                                        height: 110,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  primaryActiveColor,
                                                ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Image.file(
                                    selectedImages![index],
                                    width: 110,
                                    height: 110,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        if (enabled)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: GestureDetector(
                              onTap: () {
                                if (kIsWeb) {
                                  final updatedXFiles = List<XFile>.from(
                                    webSelectedImages!,
                                  );
                                  updatedXFiles.removeAt(index);
                                  onXFilesSelected?.call(updatedXFiles);
                                } else {
                                  final updatedImages = List<File>.from(
                                    selectedImages!,
                                  );
                                  updatedImages.removeAt(index);
                                  onImagesSelected?.call(updatedImages);
                                }
                                formKey?.currentState?.save();
                                onModified?.call();
                              },
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.red[600],
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          // Add photo buttons
          if (((kIsWeb && webSelectedImages.length < maxImages) ||
                  (!kIsWeb && selectedImages.length < maxImages)) &&
              enabled)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                              source: ImageSource.camera,
                            );

                            if (image != null) {
                              if (kIsWeb) {
                                final updatedXFiles = List<XFile>.from(
                                  webSelectedImages!,
                                )..add(image);
                                onXFilesSelected?.call(updatedXFiles);
                              } else {
                                final newFile = File(image.path);
                                final updatedImages = List<File>.from(
                                  selectedImages!,
                                )..add(newFile);
                                onImagesSelected?.call(updatedImages);
                              }
                              formKey?.currentState?.save();
                              onModified?.call();
                            }
                          },
                          icon: const Icon(Icons.camera_alt, size: 18),
                          label: const Text(
                            'Camera',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryActiveColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final List<XFile> images = await picker
                                .pickMultiImage();

                            if (images.isNotEmpty) {
                              if (kIsWeb) {
                                final updatedXFiles = List<XFile>.from(
                                  webSelectedImages!,
                                )..addAll(images);

                                // Ensure we don't exceed max images
                                if (updatedXFiles.length > maxImages) {
                                  updatedXFiles.removeRange(
                                    maxImages,
                                    updatedXFiles.length,
                                  );
                                }

                                onXFilesSelected?.call(updatedXFiles);
                              } else {
                                final newFiles = images
                                    .map((image) => File(image.path))
                                    .toList();
                                final updatedImages = List<File>.from(
                                  selectedImages!,
                                )..addAll(newFiles);

                                // Ensure we don't exceed max images
                                if (updatedImages.length > maxImages) {
                                  updatedImages.removeRange(
                                    maxImages,
                                    updatedImages.length,
                                  );
                                }

                                onImagesSelected?.call(updatedImages);
                              }
                              formKey?.currentState?.save();
                              onModified?.call();
                            }
                          },
                          icon: const Icon(Icons.photo_library, size: 18),
                          label: const Text(
                            'Gallery',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'You can select multiple photos from gallery',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          // Photo count indicator
          Text(
            kIsWeb
                ? 'Photos: ${webSelectedImages.length}/$maxImages'
                : 'Photos: ${selectedImages.length}/$maxImages',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Internal wrapper for consistent form entry styling
class _FormEntryWrapper {
  static Widget formEntry({
    String? title,
    String? subTitle,
    Widget? inputWidget,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
          ],
          if (subTitle != null) ...[
            Text(
              subTitle,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
          ],
          if (inputWidget != null) inputWidget,
        ],
      ),
    );
  }
}
