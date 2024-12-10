part of 'pages.dart';

class HitungOngkir extends StatefulWidget {
  const HitungOngkir({super.key});

  @override
  State<HitungOngkir> createState() => HitungOngkirState();
}

class HitungOngkirState extends State<HitungOngkir> {
  HomeViewmodel homeViewmodel = HomeViewmodel();
  final weightController = TextEditingController();

  @override
  void initState() {
    homeViewmodel.getProvinceList();
    weightController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  dynamic selectedOriginProvince;
  dynamic selectedDestProvince;
  dynamic selectedOriginCity;
  dynamic selectedDestCity;
  String? selectedCourier;
  List<String> couriers = ['jne', 'pos', 'tiki'];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewmodel>(
      create: (BuildContext context) => homeViewmodel,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.blue[600],
          title: Text("Hitung Ongkir",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          elevation: 0,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        shipping(),
                        SizedBox(height: 16),
                        _buildOriginSection(),
                        SizedBox(height: 16),
                        _buildDestinationSection(),
                        SizedBox(height: 24),
                        calculate(),
                        SizedBox(height: 24),
                        result(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Consumer<HomeViewmodel>(
              builder: (context, viewModel, _) {
                if (viewModel.costResult.status == Status.loading) {
                  return Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                            SizedBox(height: 16),
                            Text('Menghitung ongkos kirim...',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 24),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildStyledDropdown({
    required dynamic value,
    required String hint,
    required List<DropdownMenuItem> items,
    required Function(dynamic) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            isExpanded: true,
            value: value,
            hint: Text(hint),
            items: items,
            onChanged: onChanged,
            icon: Icon(Icons.arrow_drop_down, color: Colors.blue[600]),
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOriginSection() {
    return _buildSectionCard(
      'Lokasi Pengirim',
      Icons.location_on_outlined,
      [
        Consumer<HomeViewmodel>(
          builder: (context, value, _) {
            if (value.provinceList.status == Status.loading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            } else if (value.provinceList.status == Status.completed) {
              return Column(
                children: [
                  _buildStyledDropdown(
                    value: selectedOriginProvince,
                    hint: 'Pilih Provinsi',
                    items: value.provinceList.data!.map((province) {
                      return DropdownMenuItem(
                        value: province,
                        child: Text(province.province.toString()),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedOriginProvince = newValue;
                        selectedOriginCity = null;
                        homeViewmodel.getOriginCityList(
                            selectedOriginProvince!.provinceId!);
                      });
                    },
                  ),
                  if (selectedOriginProvince != null) ...[
                    SizedBox(height: 16),
                    Consumer<HomeViewmodel>(
                      builder: (context, value, _) {
                        if (value.originCityList.status == Status.loading) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          );
                        } else if (value.originCityList.status ==
                            Status.completed) {
                          return _buildStyledDropdown(
                            value: selectedOriginCity,
                            hint: 'Pilih Kota',
                            items: value.originCityList.data!.map((city) {
                              return DropdownMenuItem(
                                value: city,
                                child: Text("${city.cityName} (${city.type})"),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedOriginCity = newValue as City;
                              });
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ],
              );
            }
            return Container();
          },
        ),
      ],
    );
  }

  Widget _buildDestinationSection() {
    return _buildSectionCard(
      'Lokasi Penerima',
      Icons.location_pin,
      [
        Consumer<HomeViewmodel>(
          builder: (context, value, _) {
            if (value.provinceList.status == Status.loading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            } else if (value.provinceList.status == Status.completed) {
              return Column(
                children: [
                  _buildStyledDropdown(
                    value: selectedDestProvince,
                    hint: 'Pilih Provinsi',
                    items: value.provinceList.data!.map((province) {
                      return DropdownMenuItem(
                        value: province,
                        child: Text(province.province.toString()),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedDestProvince = newValue;
                        selectedDestCity = null;
                        homeViewmodel
                            .getDestCityList(selectedDestProvince!.provinceId!);
                      });
                    },
                  ),
                  if (selectedDestProvince != null) ...[
                    SizedBox(height: 16),
                    Consumer<HomeViewmodel>(
                      builder: (context, value, _) {
                        if (value.destCityList.status == Status.loading) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          );
                        } else if (value.destCityList.status ==
                            Status.completed) {
                          return _buildStyledDropdown(
                            value: selectedDestCity,
                            hint: 'Pilih Kota',
                            items: value.destCityList.data!.map((city) {
                              return DropdownMenuItem(
                                value: city,
                                child: Text("${city.cityName} (${city.type})"),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedDestCity = newValue as City;
                              });
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ],
              );
            }
            return Container();
          },
        ),
      ],
    );
  }

  bool _canCalculate() {
    print("Origin City: $selectedOriginCity");
    print("Dest City: $selectedDestCity");
    print("Courier: $selectedCourier");
    print("Weight: ${weightController.text}");

    return selectedOriginCity != null &&
        selectedDestCity != null &&
        selectedCourier != null &&
        weightController.text.isNotEmpty;
  }

  Widget shipping() {
    return _buildSectionCard(
      'Detail Pengiriman',
      Icons.fire_truck_outlined,
      [
        _buildStyledDropdown(
          value: selectedCourier,
          hint: 'Pilih Kurir',
          items: couriers
              .map((courier) => DropdownMenuItem(
                    value: courier,
                    child: Row(
                      children: [
                        Icon(Icons.fire_truck_outlined),
                        SizedBox(width: 10),
                        Text(courier.toUpperCase()),
                      ],
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedCourier = value;
            });
          },
        ),
        SizedBox(height: 16),
        TextField(
          controller: weightController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Berat (gram)',
            hintText: 'Cth: 1000',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget calculate() {
    final bool canCalculate = _canCalculate();
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[600],
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 3,
      ),
      onPressed: canCalculate
          ? () {
              homeViewmodel.calculateCost(
                origin: selectedOriginCity.cityId,
                destination: selectedDestCity.cityId,
                weight: int.parse(weightController.text),
                courier: selectedCourier!,
              );
            }
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 8),
          Text(
            'Hitung Ongkir',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget result() {
    return Consumer<HomeViewmodel>(
      builder: (context, value, _) {
        if (value.costResult.status == Status.completed &&
            value.costResult.data?.costs?.isNotEmpty == true) {
          return _buildSectionCard(
            'Hasil Pencarian',
            Icons.list_alt_outlined,
            value.costResult.data!.costs!.map((cost) {
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[50],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cost.service ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Text(
                                cost.description ?? '',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Rp ${NumberFormat("#,###").format(cost.cost?[0].value ?? 0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (cost.cost?[0].etd != null) ...[
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 16, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Text(
                            'Estimasi ${cost.cost?[0].etd} hari',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          );
        }
        return Container();
      },
    );
  }
}
