import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:admin/pages/success_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  // list kelas
  List<String> filterKelas = <String>['X', 'XI', 'XII'];
  String dropdownKelas = '';

  // list jurusan
  List<String> filterJurusan = <String>['TKJ', 'TEI', 'RPL', 'TET', 'AK', 'TO'];
  String dropdownJurusan = '';

  // list Options
  List<String> filterOptions = <String>['1', '2', '3', 'K.I'];
  String dropdownOptions = '';

  // Options List Kelas, Jurusan, Options
  @override
  void initState() {
    super.initState();
    dropdownKelas = filterKelas.first;
    dropdownJurusan = filterJurusan.first;
    dropdownOptions = filterOptions.first;
  }

  // Add Image Product
  Uint8List? _image;
  File? selectedImage;

  // Options Gallery Or Camera
  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.grey.shade200,
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(40.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 7.5,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImageFromGallery();
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(Icons.image, size: 70),
                          Text("Gallery"),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImageFromCamera();
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(Icons.camera_alt, size: 70),
                          Text("Camera"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Gallery
  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    Navigator.of(context).pop();
  }

  // Camera
  Future _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    Navigator.of(context).pop();
  }

  // Input Data Product
  final TextEditingController _nameProduct = TextEditingController();
  final TextEditingController _descriptionProduct = TextEditingController();
  final TextEditingController _priceProduct = TextEditingController();
  final TextEditingController _nameAdmin = TextEditingController();

  // Mengecek apakah inputan data sudah di isi atau belum
  void _onTap() async {
    if (_image == null) {
      _showNoImageSelectedDialog();
    } else if (_nameProduct.text.isEmpty ||
        _descriptionProduct.text.isEmpty ||
        _priceProduct.text.isEmpty ||
        _nameAdmin.text.isEmpty) {
      _showDataNotEnteredDialog();
    } else {
      // Menampilkan dialog konfirmasi sebelum menyimpan produk
      _showConfirmationDialog();
    }
  }

// Method untuk menampilkan dialog jika gambar belum dipilih
  Future<void> _showNoImageSelectedDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Image Selected'),
          content:
              const Text('Please select an image before adding the product.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // loading screen
  bool _isLoading = false;

  // Confirm (Are Yoru Sure?)
  Future<void> _showConfirmationDialog() async {
    setState(() {
      _isLoading =
          true; // Setel _isLoading menjadi true sebelum menampilkan dialog
    });

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are You Sure?'),
          content: const Text('Do not enter wrong data'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isLoading =
                      false; // Atur kembali _isLoading menjadi false setelah menutup dialog
                });
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                // Tetapkan _isLoading menjadi true jika Anda ingin menunjukkan layar loading sebelum menavigasi ke SuccessCart()
                // _isLoading = true;

                String imageURL = await uploadImageToFirebaseStorage(_image!);
                await saveProductToFirestore(imageURL);

                setState(() {
                  _isLoading =
                      false; // Setel _isLoading menjadi false setelah menyelesaikan operasi yang memakan waktu
                });

                _completePurchase();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDataNotEnteredDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Incomplete Data'),
          content: const Text('Some data has not been entered.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Navigator Jika _showConfirmationDialog ditekan "Yes"
  void _completePurchase() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SuccessCart(),
      ),
    );
  }

  // Method untuk mengunggah gambar ke Firebase Storage
  Future<String> uploadImageToFirebaseStorage(Uint8List imageBytes) async {
    try {
      // Mendapatkan referensi Firebase Storage
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Mengunggah gambar ke Firebase Storage
      await ref.putData(imageBytes);

      // Mendapatkan URL gambar yang diunggah
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  // Method untuk menyimpan data produk ke Firestore
  Future<void> saveProductToFirestore(String imageURL) async {
    try {
      // Mendapatkan referensi collection 'products'
      CollectionReference products =
          FirebaseFirestore.instance.collection('products');

      // Menyimpan data produk ke Firestore
      await products.add({
        'image': imageURL,
        'nameProduct': _nameProduct.text,
        'descriptionProduct': _descriptionProduct.text,
        'priceProduct': _priceProduct.text,
        'nameUser': _nameAdmin.text,
        'kelasUser': dropdownKelas,
        'jurusanUser': dropdownJurusan,
        'options': dropdownOptions,
      });
    } catch (e) {
      print('Error saving product to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      const Icon(
                        Icons.add_task,
                        size: 65,
                      ),

                      const SizedBox(height: 5),

                      // Welcome Back
                      Text(
                        "Create Your New Product !!",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'Information Product',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Add Image
                      IconButton(
                        onPressed: () {
                          showImagePickerOption(context);
                        },
                        icon: _image != null
                            ? Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: MemoryImage(_image!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 75,
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          "- Image Persegi ( Recommendation ) -",
                          style:
                              TextStyle(color: Colors.grey[800], fontSize: 12),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // name
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Text(
                              'Name (Product) : ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 107, 106, 106),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 5),

                      // name textfield
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
                          controller: _nameProduct,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            hintText: 'Name',
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Description
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Text(
                              'Description (Product) : ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 107, 106, 106),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 5),

                      // Description textfield
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
                          controller: _descriptionProduct,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            hintText: 'Description',
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Price
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Text(
                              'Price (Product) : ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 107, 106, 106),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 5),

                      // Price textfield
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
                          controller: _priceProduct,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            hintText: 'Price',
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal:
                                  true), // Mengatur keyboard type menjadi number dengan opsi decimal true
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(
                                r'^\d+\.?\d{0,3}')), // Mengizinkan input berupa digit dan tanda titik dengan maksimal dua digit di belakang koma
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'Information Admin',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Name
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Text(
                              'Name (Toko) : ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 107, 106, 106),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 5),

                      // name textfield
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
                          controller: _nameAdmin,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            hintText: 'Name',
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Dropdown kelas
                            Expanded(
                              // Menambahkan Expanded untuk mendukung CrossAxisAlignment.start
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade400),
                                  ),
                                  fillColor: Colors.grey.shade200,
                                  filled: true,
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                ),
                                value: dropdownKelas,
                                onChanged: (String? value) {
                                  setState(() {
                                    dropdownKelas = value!;
                                  });
                                },
                                items: filterKelas
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),

                            const SizedBox(width: 15),

                            // Dropdown jurusan
                            Expanded(
                              // Menambahkan Expanded untuk mendukung CrossAxisAlignment.start
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade400),
                                  ),
                                  fillColor: Colors.grey.shade200,
                                  filled: true,
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                ),
                                value: dropdownJurusan,
                                onChanged: (String? value) {
                                  setState(() {
                                    dropdownJurusan = value!;
                                  });
                                },
                                items: filterJurusan
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),

                            const SizedBox(width: 15),

                            // Dropdown Options
                            Expanded(
                              // Menambahkan Expanded untuk mendukung CrossAxisAlignment.start
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade400),
                                  ),
                                  fillColor: Colors.grey.shade200,
                                  filled: true,
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                ),
                                value: dropdownOptions,
                                onChanged: (String? value) {
                                  setState(() {
                                    dropdownOptions = value!;
                                  });
                                },
                                items: filterOptions
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Add Product button
                      GestureDetector(
                        onTap: _onTap,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 104, 143, 106),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'Add Product',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
