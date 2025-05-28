import 'package:opennutritracker/core/domain/entity/user_entity.dart';
import 'package:opennutritracker/core/domain/entity/user_gender_entity.dart';
import 'package:opennutritracker/core/utils/calc/bmr_calc.dart';
import 'package:opennutritracker/core/utils/calc/pal_calc.dart';

class TDEECalc {
  /// Calculates TDEE from userEntity based on the formula from
  /// 'Human energy requirements Report of a Joint FAO/WHO/UNU
  /// Expert Consultation'
  /// TDEE = BMR x PAL
  /// https://www.fao.org/3/y5686e/y5686e00.htm
  static double getTDEEKcalWHO2001(UserEntity userEntity) {
    final userBMR = BMRCalc.getBMRSchofield11985(userEntity);
    final userPAL = PalCalc.getPALValueFromActivityCategory(userEntity);
    return userBMR * userPAL;
  }

  /// Returns the total daily energy expenditure (TDEE) of given userEntity
  /// based on 2005 IOM equation
  ///
  /// Institute of Medicine. 2005. Dietary Reference Intakes for Energy,
  /// Carbohydrate, Fiber, Fat, Fatty Acids, Cholesterol, Protein,
  /// and Amino Acids. (p.204)
  /// Washington, DC: The National Academies Press.
  /// https://doi.org/10.17226/10490.
  /// https://nap.nationalacademies.org/catalog/10490/dietary-reference-intakes-for-energy-carbohydrate-fiber-fat-fatty-acids-cholesterol-protein-and-amino-acids
  static double getTDEEKcalIOM2005(UserEntity userEntity) {
    double tdeeKcal;

    if (userEntity.gender == UserGenderEntity.male) {
      tdeeKcal = 15;
    } else {
      tdeeKcal = 7;
    }

    if (userEntity.age >= 18 && userEntity.age <= 20) {
      tdeeKcal += 5;
    }
    if (userEntity.age >= 21 && userEntity.age <= 35) {
      tdeeKcal += 4;
    }
    if (userEntity.age >= 36 && userEntity.age <= 50) {
      tdeeKcal += 3;
    }
    if (userEntity.age >= 51 && userEntity.age <= 65) {
      tdeeKcal += 2;
    }
    if (userEntity.age >= 66) {
      tdeeKcal += 1;
    }

    tdeeKcal += userEntity.weightKG / 10;

    if (userEntity.heightCM > 160) {
      tdeeKcal += 2;
    } else {
      tdeeKcal += 1;
    }

    tdeeKcal += PalCalc.getPALValueFromActivityCategoryPoints(userEntity);

    return tdeeKcal;
  }
}