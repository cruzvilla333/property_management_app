import 'package:flutter/material.dart';

import 'package:training_note_app/designs/colors/app_colors.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_tenant.dart';

typedef CallBack = void Function(CloudTenant tenant);

class TenantTileListView extends StatelessWidget {
  const TenantTileListView({
    super.key,
    required this.tenants,
    required this.onTap,
    required this.onLongPress,
  });

  final Iterable<CloudTenant> tenants;

  final CallBack onTap;
  final CallBack onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tenants.length,
      itemBuilder: (context, index) {
        final tenant = tenants.elementAt(index);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListTile(
            trailing: const Icon(
              Icons.person,
              size: 100,
            ),
            tileColor: mainAppTileColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onLongPress: () => onLongPress(tenant),
            onTap: () => onTap(tenant),
            title: SizedBox(
              height: 130,
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tenant.firstName,
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: mainAppTextColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tenant.lastName,
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17,
                      color: mainAppTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
