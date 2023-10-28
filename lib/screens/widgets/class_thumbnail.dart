import 'package:flutter/material.dart';
import 'package:siklas/models/class_model.dart';
import 'package:siklas/models/floor_model.dart';
import 'package:siklas/screens/widgets/loading_circular.dart';

class ClassThumbnail extends StatelessWidget {
  final ClassModel? classModel;

  final FloorModel? floorModel;

  final double thumbnailSize;

  const ClassThumbnail({
    super.key,
    required this.classModel,
    required this.floorModel,
    this.thumbnailSize = 150
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FutureBuilder(
              future: classModel!.getImagePath(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.network(
                    snapshot.data!,
                    fit: BoxFit.cover,
                    width: thumbnailSize,
                    height: 100,
                    loadingBuilder: (context, child, loadingProgress) =>
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.black12,
                        width: thumbnailSize,
                        height: 100,
                        child: Center(
                          child: LoadingCircular(
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      ),
                  );
                }

                return SizedBox(width: thumbnailSize);
              },
            ),
          ),
          const SizedBox(width: 20,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  classModel != null ? classModel!.name : '-',
                  style: Theme.of(context).textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  floorModel != null ? floorModel!.name : '-',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}