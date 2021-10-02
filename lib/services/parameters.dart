import 'package:shared_preferences/shared_preferences.dart';

class Parameters {

  final SharedPreferences sharedPrefs;
  late int chosenIndex = 1;
  List<ParametersGroup> values = [];

  Parameters(this.sharedPrefs) {
    values = [
      ParametersGroup(sharedPrefs,
          name: 'Solar Fluxes and Related',
          params: <Parameter>[
            Parameter(
                code: 'ALLSKY_SFC_SW_DWN',
                title: 'Surface Shortwave Downward Irradiance',
                name: 'All Sky',
                details: 'The total solar irradiance incident (direct plus diffuse) on a horizontal plane at the surface of the earth under all sky conditions. An alternative term for the total solar irradiance is the "Global Horizontal Irradiance" or GHI.',
                unit: 'kW-hr/m^2/'
            ),
            Parameter(
                code: 'CLRSKY_SFC_SW_DWN',
                title: 'Surface Shortwave Downward Irradiance',
                name: 'Clear Sky',
                details: 'The total solar irradiance incident (direct plus diffuse) on a horizontal plane at the surface of the earth under clear sky conditions. An alternative term for the total solar irradiance is the "Global Horizontal Irradiance" or GHI.',
                unit: 'kW-hr/m^2/'
            ),
            Parameter(
                code: 'ALLSKY_KT',
                title: 'Insolation Clearness Index',
                name: 'All Sky',
                details: 'A fraction representing clearness of the atmosphere; the all sky insolation that is transmitted through the atmosphere to strike the surface of the earth divided by the average of top of the atmosphere total solar irradiance incident.',
                unit: ''
            ),
            Parameter(
                code: 'ALLSKY_NKT',
                title: 'Insolation Clearness Index',
                name: 'All Sky Normalized',
                details: 'The average zenith angle-independent expression of the all sky insolation clearness index.',
                unit: ''
            ),
            Parameter(
                code: 'ALLSKY_SFC_LW_DWN',
                title: 'Surface Longwave Downward Irradiance',
                name: 'All Sky',
                details: 'The downward thermal infrared irradiance under all sky conditions reaching a horizontal plane the surface of the earth. Also known as Horizontal Infrared Radiation Intensity from Sky.",',
                unit: 'W/m^2'
            ),
            Parameter(
                code: 'ALLSKY_SFC_PAR_TOT',
                title: 'Surface PAR Total',
                name: 'All Sky',
                details: 'The total Photosynthetically Active Radiation (PAR) incident on a horizontal plane at the surface of the earth under all sky conditions.',
                unit: 'W/m^2'
            ),
            Parameter(
                code: 'CLRSKY_SFC_PAR_TOT',
                title: 'Surface PAR Total',
                name: 'Clear Sky',
                details: 'The total Photosynthetically Active Radiation (PAR) incident on a horizontal plane at the surface of the earth under clear sky conditions.',
                unit: 'W/m^2'
            ),
            Parameter(
                code: 'ALLSKY_SFC_UVA',
                title: 'All Sky Surface UV Irradiance',
                name: 'UVA',
                details: 'The ultraviolet A (UVA 315nm-400nm) irradiance under all sky conditions.',
                unit: 'W/m^2'
            ),
            Parameter(
                code: 'ALLSKY_SFC_UVB',
                title: 'All Sky Surface UV Irradiance',
                name: 'UVB',
                details: 'The ultraviolet B (UVB 280nm-315nm) irradiance under all sky conditions.',
                unit: 'W/m^2'
            ),
            Parameter(
                code: 'ALLSKY_SFC_UV_INDEX',
                title: 'All Sky Surface UV Index',
                name: 'UV Index Maximum',
                details: 'The maximum ultraviolet radiation exposure index.',
                unit: ''
            ),

          ]
      ),
      ParametersGroup(sharedPrefs,
          name: "Solar Cooking",
          params: <Parameter>[
            Parameter(
                code: 'ALLSKY_SFC_SW_DWN',
                title: 'Surface Shortwave Downward Irradiance',
                name: 'All Sky',
                details: 'The total solar irradiance incident (direct plus diffuse) on a horizontal plane at the surface of the earth under all sky conditions. An alternative term for the total solar irradiance is the "Global Horizontal Irradiance" or GHI.',
                unit: 'kW-hr/m^2/'
            ),
            Parameter(
                code: 'CLRSKY_SFC_SW_DWN',
                title: 'Surface Shortwave Downward Irradiance',
                name: 'Clear Sky',
                details: 'The total solar irradiance incident (direct plus diffuse) on a horizontal plane at the surface of the earth under clear sky conditions. An alternative term for the total solar irradiance is the "Global Horizontal Irradiance" or GHI.',
                unit: 'kW-hr/m^2/'
            ),
            Parameter(
                code: 'WS2M',
                title: 'Wind Speed',
                name: 'at 2 Meters',
                details: 'The average of wind speed at 2 meters above the surface of the earth.',
                unit: 'm/s'
            ),
          ]
      ),
      ParametersGroup(sharedPrefs,
          name: "Temperatures",
          params: <Parameter>[
            Parameter(
                code: 'T2M',
                title: 'Temperature',
                name: 'at 2 Meters',
                details: 'The average air (dry bulb) temperature at 2 meters above the surface of the earth.',
                unit: '°C'
            ),
            Parameter(
                code: 'T2MDEW',
                title: '',
                name: 'Dew/Frost Point at 2 Meters',
                details: 'The dew/frost point temperature at 2 meters above the surface of the earth.',
                unit: '°C'
            ),
            Parameter(
                code: 'T2MWET',
                title: '',
                name: 'Wet Bulb Temperature at 2 Meters',
                details: 'The adiabatic saturation temperature which can be measured by a thermometer covered in a water-soaked cloth over which air is passed at 2 meters above the surface of the earth.',
                unit: '°C'
            ),
            Parameter(
                code: 'T2M_MAX',
                title: 'Temperature',
                name: 'at 2 Meters Maximum',
                details: 'The maximum air (dry bulb) temperature at 2 meters above the surface of the earth in the period of interest.',
                unit: '°C'
            ),
            Parameter(
                code: 'T2M_MIN',
                title: 'Temperature',
                name: 'at 2 Meters Minimum',
                details: 'The minimum air (dry bulb) temperature at 2 meters above the surface of the earth in the period of interest.',
                unit: '°C'
            ),
            Parameter(
                code: 'TS',
                title: 'Temperature',
                name: 'Earth Skin',
                details: 'The average temperature at the earth\'s surface.',
                unit: '°C'
            ),
          ]
      ),
      ParametersGroup(sharedPrefs,
          name: "Humidity/Precipitation",
          params: <Parameter>[
            Parameter(
                code: 'QV2M',
                title: 'Specific Humidity',
                name: 'at 2 Meters',
                details: 'The ratio of the mass of water vapor to the total mass of air at 2 meters (kg water/kg total air).',
                unit: 'g/kg'
            ),
            Parameter(
                code: 'RH2M',
                title: 'Relative Humidity',
                name: 'at 2 Meters',
                details: 'The ratio of actual partial pressure of water vapor to the partial pressure at saturation, expressed in percent.',
                unit: '%'
            ),
            Parameter(
                code: 'PRECTOTCORR',
                title: 'Precipitation',
                name: 'Precipitation',
                details: 'The bias corrected average of total precipitation at the surface of the earth in water mass (includes water content in snow).',
                unit: 'mm'
            ),
          ]
      ),
      ParametersGroup(sharedPrefs,
          name: "Wind/Pressure",
          params: <Parameter>[
            Parameter(
                code: 'WS10M',
                title: 'Wind Speed at 10 Meters',
                name: 'Value',
                details: 'The average of wind speed at 10 meters above the surface of the earth.',
                unit: 'm/s'
            ),
            Parameter(
                code: 'WS10M_MAX',
                title: 'Wind Speed at 10 Meters',
                name: 'Maximum',
                details: 'The maximum hourly wind speed at 10 meters above the surface of the earth.',
                unit: 'm/s'
            ),
            Parameter(
                code: 'WS10M_MIN',
                title: 'Wind Speed at 10 Meters',
                name: 'Minimum',
                details: 'The minimum hourly wind speed at 10 meters above the surface of the earth.',
                unit: 'm/s'
            ),
            Parameter(
                code: 'WS50M',
                title: 'Wind Speed at 50 Meters',
                name: 'Value',
                details: 'The average of wind speed at 50 meters above the surface of the earth.',
                unit: 'm/s'
            ),
            Parameter(
                code: 'WS50M_MAX',
                title: 'Wind Speed at 50 Meters',
                name: 'Maximum',
                details: 'The maximum hourly wind speed at 50 meters above the surface of the earth.',
                unit: 'm/s'
            ),
            Parameter(
                code: 'WS50M_MIN',
                title: 'Wind Speed at 50 Meters',
                name: 'Minimum',
                details: 'The minimum hourly wind speed at 50 meters above the surface of the earth.',
                unit: 'm/s'
            ),
            Parameter(
                code: 'PS',
                title: 'Pressure',
                name: 'Surface Pressure',
                details: 'The average of surface pressure at the surface of the earth.',
                unit: 'kPa'
            ),
          ]
      ),
    ];
    if (sharedPrefs.getInt('graph') == null) {
      sharedPrefs.setInt('graph', 1);
    }
    refresh();
  }

  void refresh() {
    for (int i = 0; i < values.length; i++) {
      values[i].chosen = false;
    }
    chosenIndex = sharedPrefs.getInt('graph') ?? chosenIndex;
    values[chosenIndex].chosen = true;
  }

  ParametersGroup pickNamed(String name) => values.firstWhere((group) => group.name == name);

  List<dynamic> listParametersCodes() {
    List<String> codes = [];
    for (int i = 0; i < values.length; i++) {
      codes.addAll(values[i].params.map((e) => e.code));
    }
    codes = codes.toSet().toList();
    return codes;
  }

  List<List<int>> divideParams(int index) {
    List<List<int>> params = [];
    List<String> titles = values[index].params.map((e) => e.title).toSet().toList();
    for (int i = 0; i < titles.length; i++) {
      params.add(
        values[index].params.where(
          (element) => element.title == titles[i] && element.value
        ).map((e) => values[index].params.indexOf(e)).toList()
      );
    }
    return params;
  }
}

class ParametersGroup {
  final SharedPreferences sharedPrefs;
  final String name;
  final List<Parameter> params;
  bool isExpanded = false;
  bool chosen = false;
  late String chosenParams;

  ParametersGroup(
    this.sharedPrefs,
    {required this.name, required this.params}) {
    chosenParams = ''.padLeft(params.length, '1');
    refresh();
  }

  void refresh() {
    if (sharedPrefs.getString(name) == null) {
      sharedPrefs.setString(name, chosenParams);
    } else {
      chosenParams = sharedPrefs.getString(name) ?? chosenParams;
    }
    for (int i = 0; i < chosenParams.length; i++) {
      params[i].value = chosenParams[i] == '1' ? true : false;
    }
  }
}

class Parameter {
  late final String code;
  late final String name;
  late final String title;
  late final String details;
  late final String unit;
  bool isExpanded = false;
  bool value = false;

  Parameter({
    required this.code,
    required this.title,
    required this.name,
    required this.details,
    required this.unit
  });
}