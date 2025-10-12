// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:quick_bites/Data/Api/AddModel.dart';
import 'package:quick_bites/Data/Api/Hive.dart'; // Import your DataManage class

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late Box<UserAdd> userAddressBox;
  List<UserAdd> addresses = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    userAddressBox = Hive.box<UserAdd>('userAddressBox');
    await _fetchAddressesFromAPI();
  }

  Future<void> _fetchAddressesFromAPI() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      // Fetch addresses from API
      await DataManage.fetchUserAddress();
      
      // Update local list from Hive (which should be updated by DataManage)
      getAddressesFromHive();
      
      _showSuccessSnackbar("Addresses updated successfully");
    } catch (e) {
      _showErrorSnackbar("Failed to fetch addresses");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void getAddressesFromHive() {
    setState(() {
      addresses = userAddressBox.values.toList();
    });
  }

  void _showAddAddressBottomSheet({UserAdd? editAddress}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEditAddressBottomSheet(
        address: editAddress,
        onSave: (newAddress) async {
          if (editAddress != null) {
            // Update existing address via API
            await _updateAddress(editAddress, newAddress);
          } else {
            // Add new address via API
            await _addNewAddress(newAddress);
          }
        },
      ),
    );
  }

  Future<void> _addNewAddress(UserAdd newAddress) async {
    try {
      setState(() {
        isLoading = true;
      });
      
      // Call API to add new address
      final success = await DataManage.addUserAddress(
        name: newAddress.name,
        pincode: newAddress.pincode,
        state: newAddress.state,
        district: newAddress.district,
        city: newAddress.city,
        al1: newAddress.al1,
        al2: newAddress.al2,
        type: newAddress.type,
        isDefault: newAddress.isDefault,
      );

      if (success) {
        // Refresh addresses from API after successful addition
        await _fetchAddressesFromAPI();
        _showSuccessSnackbar("Address added successfully");
      } else {
        _showErrorSnackbar("Failed to add address");
      }
    } catch (e) {
      _showErrorSnackbar("Error adding address: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateAddress(UserAdd oldAddress, UserAdd updatedAddress) async {
    try {
      setState(() {
        isLoading = true;
      });

      // Call API to update address
      final success = await DataManage.updateUserAddress(
        addressId: oldAddress.id,
        name: updatedAddress.name,
        pincode: updatedAddress.pincode,
        state: updatedAddress.state,
        district: updatedAddress.district,
        city: updatedAddress.city,
        al1: updatedAddress.al1,
        al2: updatedAddress.al2,
        type: updatedAddress.type,
        isDefault: updatedAddress.isDefault,
      );

      if (success) {
        // Refresh addresses from API after successful update
        await _fetchAddressesFromAPI();
        _showSuccessSnackbar("Address updated successfully");
      } else {
        _showErrorSnackbar("Failed to update address");
      }
    } catch (e) {
      _showErrorSnackbar("Error updating address: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _deleteAddress(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Delete Address",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Are you sure you want to delete this address?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteAddressFromAPI(id);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAddressFromAPI(String id) async {
    try {
      setState(() {
        isLoading = true;
      });

      // Call API to delete address
      final success = await DataManage.deleteUserAddress(id);

      if (success) {
        // Refresh addresses from API after successful deletion
        await _fetchAddressesFromAPI();
        _showSuccessSnackbar("Address deleted successfully");
      } else {
        _showErrorSnackbar("Failed to delete address");
      }
    } catch (e) {
      _showErrorSnackbar("Error deleting address: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _setDefaultAddress(String id) async {
    try {
      setState(() {
        isLoading = true;
      });

      // Call API to set default address
      final success = await DataManage.setDefaultAddress(id);

      if (success) {
        // Refresh addresses from API after setting default
        await _fetchAddressesFromAPI();
        _showSuccessSnackbar("Default address updated successfully");
      } else {
        _showErrorSnackbar("Failed to set default address");
      }
    } catch (e) {
      _showErrorSnackbar("Error setting default address: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "My Addresses",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(LucideIcons.refreshCw),
            onPressed: _fetchAddressesFromAPI,
          ),
        ],
      ),
      body: Column(
        children: [
          // Add Address Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : () => _showAddAddressBottomSheet(),
                icon: const Icon(LucideIcons.plus, size: 20),
                label: const Text(
                  "Add New Address",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
              ),
            ),
          ),

          // Address List
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                    ),
                  )
                : addresses.isEmpty
                    ? const EmptyAddressState()
                    : RefreshIndicator(
                        onRefresh: _fetchAddressesFromAPI,
                        color: const Color(0xFFFF6B35),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: addresses.length,
                          itemBuilder: (context, index) {
                            final address = addresses[index];
                            return AddressCard(
                              address: address,
                              onEdit: () => _showAddAddressBottomSheet(editAddress: address),
                              onDelete: () => _deleteAddress(address.id),
                              onSetDefault: () => _setDefaultAddress(address.id),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final UserAdd address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const AddressCard({
    super.key,
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    final isDefault = address.isDefault == "1";
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Default Badge
                if (isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "DEFAULT",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFF6B35),
                      ),
                    ),
                  ),

                const SizedBox(height: 12),

                // Name
                Text(
                  address.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                // Address Lines
                Text(
                  address.al1,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),

                if (address.al2.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    address.al2,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],

                const SizedBox(height: 4),

                // City, District, State
                Text(
                  "${address.city}, ${address.district}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 4),

                // State and Pincode
                Text(
                  "${address.state} - ${address.pincode}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    // Edit Button
                    _buildActionButton(
                      icon: LucideIcons.edit,
                      text: "Edit",
                      color: const Color(0xFFFF6B35),
                      onTap: onEdit,
                    ),

                    const SizedBox(width: 12),

                    // Set Default Button
                    if (!isDefault)
                      _buildActionButton(
                        icon: LucideIcons.star,
                        text: "Set Default",
                        color: Colors.amber,
                        onTap: onSetDefault,
                      ),

                    const Spacer(),

                    // Delete Button
                    _buildActionButton(
                      icon: LucideIcons.trash2,
                      text: "Delete",
                      color: Colors.red,
                      onTap: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddEditAddressBottomSheet extends StatefulWidget {
  final UserAdd? address;
  final Function(UserAdd) onSave;

  const AddEditAddressBottomSheet({
    super.key,
    this.address,
    required this.onSave,
  });

  @override
  State<AddEditAddressBottomSheet> createState() => _AddEditAddressBottomSheetState();
}

class _AddEditAddressBottomSheetState extends State<AddEditAddressBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _stateController = TextEditingController();
  final _districtController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _nameController.text = widget.address!.name;
      _pincodeController.text = widget.address!.pincode;
      _stateController.text = widget.address!.state;
      _districtController.text = widget.address!.district;
      _cityController.text = widget.address!.city;
      _addressLine1Controller.text = widget.address!.al1;
      _addressLine2Controller.text = widget.address!.al2;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pincodeController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    _cityController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      final newAddress = UserAdd(
        id: widget.address?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        userId: widget.address?.userId ?? "current_user_id",
        type: widget.address?.type ?? "home",
        name: _nameController.text.trim(),
        pincode: _pincodeController.text.trim(),
        state: _stateController.text.trim(),
        district: _districtController.text.trim(),
        city: _cityController.text.trim(),
        al1: _addressLine1Controller.text.trim(),
        al2: _addressLine2Controller.text.trim(),
        createdAt: widget.address?.createdAt ?? DateTime.now().toIso8601String(),
        isDefault: widget.address?.isDefault ?? "0",
      );

      await widget.onSave(newAddress);
      
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.address != null;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                  icon: const Icon(LucideIcons.x, size: 24),
                ),
                const SizedBox(width: 8),
                Text(
                  isEditing ? "Edit Address" : "Add New Address",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (_isSaving)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                    ),
                  ),
                if (isEditing && !_isSaving)
                  IconButton(
                    onPressed: _saveAddress,
                    icon: const Icon(LucideIcons.check, size: 24),
                  ),
              ],
            ),
          ),

          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: "Full Name",
                      icon: LucideIcons.user,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _pincodeController,
                      label: "Pincode",
                      icon: LucideIcons.mapPin,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter pincode';
                        }
                        if (value.length != 6) {
                          return 'Pincode must be 6 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _stateController,
                      label: "State",
                      icon: LucideIcons.map,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter state';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _districtController,
                      label: "District",
                      icon: LucideIcons.map,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter district';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _cityController,
                      label: "City",
                      icon: LucideIcons.building,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter city';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _addressLine1Controller,
                      label: "Address Line 1",
                      icon: LucideIcons.home,
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter address line 1';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _addressLine2Controller,
                      label: "Address Line 2 (Optional)",
                      icon: LucideIcons.home,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 30),

                    // Save Button
                    if (!isEditing)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveAddress,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  "Save Address",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      enabled: !_isSaving,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFFF6B35)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

class EmptyAddressState extends StatelessWidget {
  const EmptyAddressState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.mapPin,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 20),
          Text(
            "No Addresses Yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Add your first address to get started",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}