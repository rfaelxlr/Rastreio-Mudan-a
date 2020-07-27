class DataRastreio{
  double _longitude;
  double _latitude;
  bool _location;
  DataRastreio();
  
 double get longitude => _longitude;

 set longitude(double value) => _longitude = value;

 double get latitude => _latitude;

 set latitude(double value) => _latitude = value;

 bool get location => _location;

 set location(bool value) => _location = value;
}