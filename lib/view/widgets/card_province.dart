part of 'widgets.dart';

class CardProvince extends StatefulWidget {
  final Province province;
  const CardProvince(this.province);

  @override
  State<CardProvince> createState() => _CardProvinceState();
}

class _CardProvinceState extends State<CardProvince> {
  @override
  Widget build(BuildContext context) {
    Province prov = widget.province;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      color: Colors.white,
      elevation: 4,
      child: ListTile(
        contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 8),
        title: Text(prov.province.toString()),
        subtitle: Text("Province ID: ${prov.provinceId}"),
        leading: const CircleAvatar(
          backgroundColor: Color.fromARGB(255, 217, 216, 216),
          child: Icon(Icons.person_outlined),
        ),
        trailing: IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
      ),
    );
  }
}
