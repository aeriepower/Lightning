
public class EuNifValidator {

	public static Map<String, ValidationResult> validatedNifs = new Map<String, ValidationResult>();


	public static ValidationResult validateNif(String nif) {
		List<String> countryList = EuNifValidator.getAllEuCountries();
		if(EuNifValidator.validatedNifs.containsKey(nif)) {
			return EuNifValidator.validatedNifs.get(nif);
		}

		nif = nif.toUpperCase();
		ValidationResult res = new ValidationResult();
		String country = nif.substring(0,2);
		nif = nif.substring(2,nif.length());
		System.debug('Country: ' + country);
		if (countryList.contains(country)) {
			switch on country  {
				when 'AT' { res = isValidAustria(nif);}
				when 'BE' { res = isValidBelgium(nif);}
				when 'BG' { res = isValidBulgaria(nif); }
				when 'CY' { res = isValidCyprus(nif); }
				when 'CZ' { res = isValidCzechRepublic(nif); }
				when 'DE' { res = isValidGermany(nif); }
				when 'DK' { res = isValidDenmark(nif); }
				when 'ES' { res = isValidSpain(nif); }
				when 'HR' { res = isValidCroatia(nif); }
				when 'EE' { res = isValidEstonia(nif); }
				when 'FI' { res = isValidFinland(nif); }
				when 'FR' { res = isValidFrance(nif); }
				when 'GB' { res = isValidUK(nif); }
				when 'GR' { res = isValidGreece(nif); }
				when 'EL' { res = isValidGreece(nif); }
				when 'HU' { res = isValidHungary(nif);}
				when 'IE' { res = isValidIreland(nif);}
				when 'IT' { res = isValidItaly(nif);}
				when 'LV' { res = isValidLatvia(nif);}
				when 'LT' { res = isValidLithuania(nif);}
				when 'LU' { res = isValidLuxemburg(nif);}
				when 'MT' { res = isValidMalta(nif);}
				when 'NL' { res = isValidNetherlands(nif);}
				when 'PL' { res = isValidPoland(nif);}
				when 'PT' { res = isValidPortugal(nif);}
				when 'RO' { res = isValidRomania(nif);}
				when 'SE' { res = isValidSweden(nif);}
				when 'SK' { res = isValidSlovakia(nif);}
				when 'SI' { res = isValidSlovenia(nif);}
			}
		}else {
			res.result = 2;
		}

		res.validatedNif = nif;
		EuNifValidator.validatedNifs.put(nif, res);
		return res;
	}

	public static ValidationResult isValidAustria(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^U{1})([0-9]{1,7})([0-9]{1}$)', cNif)) {
			return res; // Si no coincide con ningun formato es invalido
		}
		// Si coincide con alguno seguimos validando las letras
		String tip = cNif.toUpperCase().substring(0, 1); // Primer digito. Siempre U
		String nums = cNif.substring(1, cNif.length() - 1); // Siguientes dígitos (1-7 números)
		String ctrl = cNif.substring(cNif.length() - 1); // Dígito de control. Un número

		// Rellena con 0s hasta que sean 7 dígitos
		nums = nums.leftPad(7, '0');

		// Validación de la letra de control
		Integer check = 0;
		String check2 = '';
		for (Integer i = 0; i < nums.length(); i++) {
			String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i, i + 1);
			String aux = Math.mod(i, 2) == 0 ? Integer.valueOf(num) * 1 + '0' :
						 Integer.valueOf(num) * 2 + '0'; // Multiplica los impares por 2
			check += Integer.valueOf(aux.substring(0, 1)) + Integer.valueOf(aux.substring(1, 2));
		}
		check = 10 - Math.mod((check + 4), 10);
		check = check == 10 ? 0 : check;
		check2 = String.valueOf(check);

		if (ctrl != check2) {
			return res; // Invalid check
		}

		res.result = 0;
		res.validatedNif = tip + nums + ctrl;
		return res;
	}

	public static ValidationResult isValidBelgium(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[0-9]{1,8})([0-9]{2}$)', cNif)) {
			return res; // Si no coincide con ningun formato es invalido
		}
		// Si coincide con alguno seguimos validando las letras
		String nums = cNif.substring(0, cNif.length() - 2); // Siguientes dígitos (1-8 números)
		String ctrl = cNif.substring(cNif.length() - 2); // Dígito de control. Dos numeros

		// Rellena con 0s hasta que sean 8 dígitos
		nums = nums.leftPad(8, '0');

		if (Integer.valueOf(nums.substring(1, 2)) < 2) {
			return res; // Invalid value
		}

		String check2 = String.valueOf(97 - Math.mod(Integer.valueOf(nums), 97)).leftPad(2, '0');

		if (ctrl != check2) {
			return res; // Invalid check
		}

		res.result = 0;
		res.validatedNif = nums + ctrl;
		return res;
	}

	public static ValidationResult isValidBulgaria(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[0-9]{1,9})([0-9]{1}$)', cNif)) {
			return res; // Si no coincide con ningun formato es invalido
		}
		// Si coincide con alguno seguimos validando las letras
		String nums = cNif.substring(0, cNif.length() - 1); // Siguientes dígitos (1-9 números)
		String ctrl = cNif.substring(cNif.length() - 1); // Dígito de control. Un número

		// Rellena con 0s hasta que sean 9 dígitos
		nums = nums.leftPad(9, '0');

		if (Pattern.matches('[23]', nums.substring(0, 1)) && nums.substring(1, 3) != '22') {
			return res; // Invalid value
		}

		list<Integer> CHG = new list <Integer>{4, 3, 2, 7, 6, 5, 4, 3, 2};
		Integer check = 0;
		String check2 = '';
		for (Integer i = 0; i < nums.length(); i++) {
			String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i, i + 1);
			check += CHG[i] * Integer.valueOf(num);
		}

		check = 11 - Math.mod(check, 11);
		check = check == 11 ? 0 : check;
		if (check == 10) {
			return res; // Invalid Value
		}
		check2 = String.valueOf(check);

		if (ctrl != check2) {
			return res; // Invalid check
		}

		res.result = 0;
		res.validatedNif = nums + ctrl;
		return res;
	}

	public static ValidationResult isValidCyprus(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[0-9]{1,8})([A-Z]{1}$)', cNif)) {
			return res; // Si no coincide con ningun formato es invalido
		}
		// Si coincide con alguno seguimos validando las letras
		String nums = cNif.substring(0, cNif.length() - 1); // Siguientes dígitos (1-8 números)
		String ctrl = cNif.substring(cNif.length() - 1); // Dígito de control. Un número

		// Rellena con 0s hasta que sean 8 dígitos
		nums = nums.leftPad(8, '0');

		if (!Pattern.matches('[013459]', nums.substring(0, 1))) {
			return res; // Invalid value
		}

		list<String> CHG = new list <String>{'1', '0', '5', '7', '9', '13', '15', '17', '19', '21'};
		Integer check = 0;
		String check2 = '';
		for (Integer i = 0; i < nums.length(); i++) {
			String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i, i + 1);
			if (Math.mod(i, 2) == 0) {
				check += Integer.valueOf(CHG[Integer.valueOf(num)]);
			} else {
				check += Integer.valueOf(num);
			}

		}

		check2 = Math.mod(check, 26) < 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.length() ? 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.substring(
				Math.mod(check, 26), Math.mod(check, 26) + 1) : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.substring(
				Math.mod(check, 26));
		if (ctrl != check2) {
			return res; // Invalid check
		}

		res.result = 0;
		res.validatedNif = nums + ctrl;
		return res;
	}

	public static ValidationResult isValidCzechRepublic(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		String nums = '';
		String ctrl = '';
		if (!Pattern.matches('(^[012345678][0-9]{6})([0-9]{1}$)', cNif)) {
			if (!Pattern.matches('(^[6][0-9]{7})([0-9]{1}$)', cNif)) {
				if (!Pattern.matches('(^[0-9]{9}$)', cNif)) {
					if (!Pattern.matches('(^[0-9]{10}$)', cNif)) {
						return res; // Si no coincide con ningun formato es invalido
					} else {
						nums = cNif; // Siguientes dígitos (1-9 números)
					}
				} else {
					nums = cNif; // Siguientes dígitos (1-9 números)
				}
			} else {
				nums = cNif.substring(0, cNif.length() - 1); // Siguientes dígitos (8 números)
				ctrl = cNif.substring(cNif.length() - 1); // Dígito de control. Un número
			}
		} else {
			nums = cNif.substring(0, cNif.length() - 1); // Siguientes dígitos (7 números)
			ctrl = cNif.substring(cNif.length() - 1); // Dígito de control. Un número
		}

		// Si coincide con alguno seguimos validando las letras
		if (nums.length() > 8) {
			if (nums.length() == 9) {
				if (Integer.valueOf(nums.substring(0, 3)) > 53 && Integer.valueOf(nums.substring(0, 3)) < 80) {
					return res; // invalid value
				}
			} else if (Integer.valueOf(nums.substring(0, 3)) < 54) {
				return res; // invalid value
			}
			if (Integer.valueOf(nums.substring(2, 4)) < 1 ||
							Integer.valueOf(nums.substring(2, 4)) > 12 && Integer.valueOf(nums.substring(2, 4)) < 51 ||
					Integer.valueOf(nums.substring(2, 4)) > 62) {
				return res; // invalid value
			}
			if (Integer.valueOf(nums.substring(4, 6)) < 1) {
				return res; // invalid value
			}
			if (Pattern.matches('02|52', nums.substring(2, 4))) {
				if (Math.mod(Integer.valueOf(nums.substring(2, 4)), 4) > 0) {
					if (Integer.valueOf(nums.substring(4, 6)) > 28) {
						return res; // invalid value
					}
				} else if (Integer.valueOf(nums.substring(4, 6)) > 29) {
					return res; // invalid value
				}
			} else if (Pattern.matches('04|06|09|11|54|56|59|61', nums.substring(2, 4))) {
				if (Integer.valueOf(nums.substring(4, 6)) > 30) {
					return res; // invalid value
				}
			} else if (Integer.valueOf(nums.substring(4, 6)) > 31) {
				return res; // invalid value
			}
		}

		Integer check = 0;
		String check2 = '';
		if (nums.length() < 9) {
			list<Integer> CHG = new list <Integer>{8, 7, 6, 5, 4, 3, 2};

			for (Integer i = 0; i < 7; i++) {
				Integer add = nums.length() == 8 ? 1 : 0;
				String num = i == nums.length() - 1 ? nums.substring(i + add) : nums.substring(i + add, i + add + 1);
				check += CHG[i] * Integer.valueOf(num);
			}
			if (nums.length() == 7) {
				check = 11 - Math.mod(check, 11);
				check = check == 10 ? 0 : check;
				check = check == 11 ? 1 : check;
			} else {
				check = 9 - Math.mod((11 - Math.mod(check, 11)), 10);
			}
			check2 = String.valueOf(check);
			if (ctrl != check2) {
				return res; // Invalid check
			}
		} else if (nums.length() == 9) {
			// do nothing
		} else {
			for (Integer i = 0; i < nums.length(); i = i + 2) {
				String num = i == nums.length() - 2 ? nums.substring(i) : nums.substring(i, i + 2);
				check += Integer.valueOf(num);
			}
			if (Math.mod(check, 11) > 0 || Math.mod(Long.valueOf(nums), 11) > 0) {
				return res; // invalid check
			}
		}

		res.result = 0;
		res.validatedNif = nums + ctrl;
		return res;
	}

	public static ValidationResult isValidCroatia(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[0-9]{1,10})([0-9]{1}$)$', cNif)) {
			return res; // Si no coincide con ningun formato es invalido
		}
		// Si coincide con alguno seguimos validando las letras
		String nums = cNif.substring(0, cNif.length() - 1); // Siguientes dígitos (1-10 números)
		String ctrl = cNif.substring(cNif.length() - 1); // Dígito de control. Un número

		if (Long.valueOf(nums) == 0) {
			return res;
		}

		// Rellena con 0s hasta que sean 10 dígitos
		nums = nums.leftPad(10, '0');

		Long check = 0;
		String check2 = '';
		for (Integer i = 0; i < nums.length(); i++) {
			String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i,
							i + 1); // digito del nif para cada iteracion
			check = Math.mod(2 * (Math.mod(Long.valueOf(num) + check + 9, 10) + 1), 11);
		}
		check = 11 - check;
		check = check == 10 ? 0 : check;
		check2 = String.valueOf(check);

		if (ctrl != check2) {
			return res; // Invalid check
		}

		res.result = 0;
		res.validatedNif = nums + ctrl;
		return res;
	}

	public static ValidationResult isValidGermany(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[0-9]{1,8})([0-9]{1}$)', cNif)) {
			return res; // Si no coincide con ningun formato es invalido
		}
		// Si coincide con alguno seguimos validando las letras
		String nums = cNif.substring(0, cNif.length() - 1); // Siguientes dígitos (1-8 números)
		String ctrl = cNif.substring(cNif.length() - 1); // Dígito de control. Un número

		if (Integer.valueOf(nums) == 0) {
			return res;
		}

		// Rellena con 0s hasta que sean 8 dígitos
		nums = nums.leftPad(8, '0');

		Integer check = 0;
		String check2 = '';
		for (Integer i = 0; i < nums.length(); i++) {
			String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i,
							i + 1); // Digito del nif para cada iteracion
			check = Math.mod(2 * (Math.mod(Integer.valueOf(num) + check + 9, 10) + 1), 11);
		}
		check = 11 - check;
		check = check == 10 ? 0 : check;
		check2 = String.valueOf(check);

		if (ctrl != check2) {
			return res; // Invalid check
		}

		res.result = 0;
		res.validatedNif = nums + ctrl;
		return res;
	}

	public static ValidationResult isValidDenmark(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[0-9]{1,8})', cNif)) {
			return res; // Si no coincide con ningun formato es invalido
		}
		// Si coincide con alguno seguimos validando las letras
		String nums = cNif.substring(0); // Siguientes dígitos (1-8 números)
		String ctrl = '';

		if (Integer.valueOf(nums.substring(0, 1)) < 1) {
			return res;
		}

		// Rellena con 0s hasta que sean 7 dígitos, excepto el primer número
		nums = nums.substring(0, 1) + nums.substring(1).leftPad(7, '0');

		Integer check = 2 * Integer.valueOf(nums.substring(0, 1));
		String check2 = '';
		for (Integer i = 1; i < nums.length(); i++) {
			String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i,
							i + 1); // Digito del nif para cada iteracion
			check += (8 - i) * Integer.valueOf(num) ;
		}
		if (Math.mod(check, 11) > 0) {
			return res;
		}

		res.result = 0;
		res.validatedNif = nums + ctrl;
		return res;
	}

	public static ValidationResult isValidEstonia(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[0-9]{1,8})([0-9]{1}$)', cNif)) {
			return res; // Si no coincide con ningun formato es invalido
		}
		// Si coincide con alguno seguimos validando las letras
		String nums = cNif.substring(0, cNif.length() - 1);
		String ctrl = cNif.substring(cNif.length() - 1); // Dígito de control. Puede ser una letra o un número

		nums = nums.leftPad(8, '0');
		list<Integer> CHG = new list <Integer>{3, 7, 1, 3, 7, 1, 3, 7};

		Integer check = 0;
		String check2 = '';
		for (Integer i = 0; i < nums.length(); i++) {
			String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i,
							i + 1); // digito del nif para cada iteracion
			check += CHG[i] * Integer.valueOf(num) ;
		}
		check = 10 - Math.mod(check, 10);
		check = check == 10 ? 0 : check;
		check2 = String.valueOf(check);

		if (ctrl != check2) {
			return res;
		}

		res.result = 0;
		res.validatedNif = nums + ctrl;
		return res;
	}

	public static ValidationResult isValidSpain(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';
		System.debug('Checkpoint 1');

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[A-Z]{1})([0-9]{1,7})([0-9]{1}$)', cNif)) {
			if (!Pattern.matches('(^[A-Z]{1})([0-9]{1,7})([A-Z]{1}$)', cNif)) {
				if (!Pattern.matches('()(^[0-9]{1,8})([A-Z]{1}$)', cNif)) {
					return res; // Si no coincide con ningun formato es invalido
				}
			}
		}
		// Si coincide con alguno seguimos validando las letras
		String tip = cNif.substring(0, 1); // Primer digito. Puede ser número (DNI) o letra (NIF, CIF)
		String nums = Pattern.matches('[A-Z]', tip) ? cNif.substring(1, cNif.length() - 1) : cNif.substring(0,
						cNif.length() - 1); // Siguientes dígitos (1-7 o 1-8 números)
		String ctrl = cNif.substring(cNif.length() - 1); // Dígito de control. Puede ser una letra o un número

		if (Pattern.matches('[A-Z]', tip)) {
			// Si es Letra añadimos hasta 7 dígitos con 0
			nums = nums.leftPad(7, '0');
		} else if (Pattern.matches('[0-9]', tip)) {
			// Si es número añadimos hasta 8 dígitos con 0
			nums = nums.leftPad(8, '0');
		}

		Integer check = 0;
		String check2 = '';
		if (Pattern.matches('[A-H]|[JNPQRSUVW]', tip)) {
			for (Integer i = 0; i < nums.length(); i++) {
				String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i, i + 1);
				String aux = Math.mod(i, 2) > 0 ? Integer.valueOf(num) * 1 + '0' :
							 Integer.valueOf(num) * 2 + '0'; // Multiplica los pares por 2
				check += Integer.valueOf(aux.substring(0, 1)) + Integer.valueOf(aux.substring(1, 2));
			}
			check = 10 - Math.mod(check, 10);
			check = check == 10 ? 0 : check;
			check2 = String.valueOf(check);
			if (Pattern.matches('[NPQRSW]', tip)) {
				check2 = 'JABCDEFGHI'.substring(check, check + 1);
			}
		} else if (Pattern.matches('[KLMX0-9]', tip)) {
			check = Math.mod(Integer.valueOf(nums), 23);
			check2 = 'TRWAGMYFPDXBNJZSQVHLCKE'.substring(check, check + 1);
		} else if (Pattern.matches('[Y]', tip)) {
			check = Math.mod(10000000 + Integer.valueOf(nums), 23);
			check2 = 'TRWAGMYFPDXBNJZSQVHLCKE'.substring(check, check + 1);
		} else if (Pattern.matches('[Z]', tip)) {
			check = Math.mod(20000000 + Integer.valueOf(nums), 23);
			check2 = 'TRWAGMYFPDXBNJZSQVHLCKE'.substring(check, check + 1);
		} else {
			return res; // Invalid value
		}
		if (ctrl != check2) {
			System.debug('Checkpoint 2');
			return res; // Invalid check
		}
		System.debug('Checkpoint 3');
		res.result = 0;
		res.validatedNif = Pattern.matches('[A-Z]', tip) ? tip + nums + ctrl : nums + ctrl;
		return res;
	}

	public static ValidationResult isValidFinland(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[0-9]{1,7})([0-9]{1}$)', cNif)) {
			return res; // Si no coincide con ningun formato es invalido
		}
		// Si coincide con alguno seguimos validando las letras
		String nums = cNif.substring(0, cNif.length() - 1);
		String ctrl = cNif.substring(cNif.length() - 1); // Dígito de control. Un numero

		nums = nums.leftPad(7, '0');
		list<Integer> CHG = new list <Integer>{7, 9, 10, 5, 8, 4, 2};

		Integer check = 0;
		String check2 = '';
		for (Integer i = 0; i < nums.length(); i++) {
			String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i,
							i + 1); // Digito del nif para cada iteracion
			check += CHG[i] * Integer.valueOf(num) ;
		}
		check = 11 - Math.mod(check, 11);
		check = check == 11 ? 0 : check;
		if (check == 10) {
			return res;
		}
		check2 = String.valueOf(check);

		if (ctrl != check2) {
			return res;
		}

		res.result = 0;
		res.validatedNif = nums + ctrl;
		return res;
	}

	public static ValidationResult isValidFrance(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[0-9]{2})([0-9]{1,9}$)', cNif)) {
			if (!Pattern.matches('(^[0-9a-zA-Z]{2})([0-9]{1,9}$)', cNif)) {
				return res; // Si no coincide con ningun formato es invalido
			}
		}
		// Si coincide con alguno seguimos validando las letras
		String ctrl = cNif.substring(0, 2); // Dígitos de control. Puede ser letras o numeros
		String nums = cNif.substring(2);

		nums = nums.leftPad(9, '0');

		Integer check = 0;
		String check2 = '';
		if (Integer.valueOf(nums) == 0) {
			return res;
		} else if (Pattern.matches('I|O', ctrl)) {
			return res;
		} else if (ctrl.isNumeric()) {
			check2 = String.valueOf(Math.mod(Math.mod(Integer.valueOf(nums), 97) * 100 + 12, 97)).leftPad(2, '0');
			if (ctrl != check2) {
				return res;
			}
		} else if (Pattern.matches('[A-Z]', ctrl.substring(0, 1)) == Pattern.matches('[A-Z]', ctrl.substring(1, 2))) {
			return res;
		} else {

			String CHG = '0123456789ABCDEFGHJKLMNPQRSTUVWXYZ';
			Integer c = CHG.indexOf(ctrl.substring(0, 1));
			check = (c < 10 ? c * 24 - 10 : c * 34 - 100) + CHG.indexOf(ctrl.substring(1, 2));
			c = Math.mod(check, 11);
			check = Integer.valueOf(Math.floor(check / 11) + 1);
			if (c != Math.mod(Integer.valueOf(nums) + check, 11)) {
				return res;
			}
		}

		res.result = 0;
		res.validatedNif = ctrl + nums;
		return res;
	}

	public static ValidationResult isValidUK(String nif) {
		System.debug('Entro a validar el nif de UK');
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico

		String tip = '';
		String nums = '';
		String ctrl = '';
		if (!Pattern.matches('(^000|^001)([0-9]{9})([3]{1}$)', cNif)) {
			if (!Pattern.matches('(^000|^001)([0-9]{9}$)()', cNif)) {
				if (!Pattern.matches('()(^[0-9]{9})([3]{1}$)', cNif)) {
					if (!Pattern.matches('()(^[0-9]{12}$)()', cNif)) {
						if (!Pattern.matches('()(^[0-9]{9}$)()', cNif)) {
							if (!Pattern.matches('(^HA)(8888[0-9]{3})([0-9]{2}$)', cNif)) {
								if (!Pattern.matches('(^GD)(8888[0-9]{3})([0-9]{2}$)', cNif)) {
									if (!Pattern.matches('(^HA)([0-9]{3}$)()', cNif)) {
										if (!Pattern.matches('(^GD)([0-9]{3}$)()', cNif)) {
											return res; // Si no coincide con ningun formato es invalido
										} else {
											tip = cNif.substring(0, 2);
											nums = cNif.substring(2);
										}
									} else {
										tip = cNif.substring(0, 2);
										nums = cNif.substring(2);
									}
								} else {
									tip = cNif.substring(0, 2);
									nums = cNif.substring(2, cNif.length() - 2);
									ctrl = cNif.substring(cNif.length() - 2);
								}
							} else {
								tip = cNif.substring(0, 2);
								nums = cNif.substring(2, cNif.length() - 2);
								ctrl = cNif.substring(cNif.length() - 2);
							}
						} else {
							nums = cNif.substring(0);
						}
					} else {
						nums = cNif.substring(0);
					}
				} else {
					nums = cNif.substring(0, cNif.length() - 1);
					ctrl = cNif.substring(cNif.length() - 1);
				}
			} else {
				tip = cNif.substring(0, 3);
				nums = cNif.substring(3);
			}
		} else {
			tip = cNif.substring(0, 3);
			nums = cNif.substring(3, cNif.length() - 1);
			ctrl = cNif.substring(cNif.length() - 1);
		}

		Integer check = 0;
		String check2 = '';
		if (tip == 'GD' || tip == 'HA') {
			if (nums.length() > 3 && nums.substring(0, 4) == '8888') {
				check = Math.mod(Integer.valueOf(nums.substring(4)), 97);
				check2 = String.valueOf(check);
				if (ctrl != check2) {
					return res;
				}
			} else if (tip == 'GD' && Integer.valueOf(nums) > 499) {
				return res;
			} else if (tip == 'HA' && Integer.valueOf(nums) < 500) {
				return res;
			}
		} else {
			if (Integer.valueOf(nums.substring(0, 7)) < 1) {
				return res;
			}
			if (Integer.valueOf(nums.substring(nums.length() - 2)) >= 97) {
				return res;
			}
			if (ctrl != '' && ctrl != '3') {
				return res;
			}
			list<Integer> CHG = new list <Integer>{8, 7, 6, 5, 4, 3, 2, 10, 1};
			check = 0;
			for (Integer i = 0; i < 9; i++) {
				String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i,
								i + 1); // Digito del nif para cada iteracion
				check += CHG[i] * Integer.valueOf(num) ;
			}
			check = Math.mod(check, 97);
			if (Integer.valueOf(nums.substring(0, 3)) < 100) {
				if (check > 0) {
					return res;
				}
			} else if (check != 0 && check != 42 && check != 55) {
				return res;
			}
		}

		res.result = 0;
		res.validatedNif = tip + nums + ctrl;
		System.debug('Res: ' + res);
		return res;
	}

	public static ValidationResult isValidGreece(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[0-9]{8})([0-9]{1}$)', cNif)) {
			if (!Pattern.matches('(^[0-9]{7})([0-9]{1}$)', cNif)) {
				return res; // Si no coincide con ningun formato es invalido
			}
		}
		// Si coincide con alguno seguimos validando las letras
		String nums = cNif.substring(0, cNif.length() - 1); // Dígito de control. Un Numero
		String ctrl = cNif.substring(cNif.length() - 1);

		Integer check = 0;
		String check2 = '';
		for (Integer i = 0; i < nums.length(); i++) {
			String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i,
							i + 1); // Digito del nif para cada iteracion
			check += Integer.valueOf(Math.pow(2, nums.length() - i)) * Integer.valueOf(num);
		}
		check = Math.mod(check, 11);
		check = check == 10 ? 0 : check;
		check2 = String.valueOf(check);
		if (ctrl != check2) {
			return res;
		}

		res.result = 0;
		res.validatedNif = nums + ctrl;
		return res;
	}

	public static ValidationResult isValidHungary(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[0-9]{1,7})([0-9]{1}$)', cNif)) {
			return res; // Si no coincide con ningun formato es invalido
		}
		// Si coincide con alguno seguimos validando las letras
		String nums = cNif.substring(0, cNif.length() - 1); // Dígito de control. Un Numero
		String ctrl = cNif.substring(cNif.length() - 1);

		nums = nums.leftPad(7, '0');
		if (nums.substring(0, 1) == '0') {
			return res;
		}

		list<Integer> CHG = new list <Integer>{9, 7, 3, 1, 9, 7, 3};
		Integer check = 0;
		String check2 = '';
		for (Integer i = 0; i < nums.length(); i++) {
			String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i,
							i + 1); // Digito del nif para cada iteracion
			check += CHG[i] * Integer.valueOf(num) ;
		}
		check = 10 - Math.mod(check, 10);
		check = check == 10 ? 0 : check;
		check2 = String.valueOf(check);
		if (ctrl != check2) {
			return res;
		}

		res.result = 0;
		res.validatedNif = nums + ctrl;
		return res;
	}

	public static ValidationResult isValidIreland(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		String tip = '';
		String nums = '';
		String ctrl = '';
		if (!Pattern.matches('(^[0-9]{1})([A-Z\\*\\+]{1})([0-9]{1,5})([A-Z]{1}$)', cNif)) {
			if (!Pattern.matches('()()(^[0-9]{1,7})([A-Z]{1}$)', cNif)) {
				return res; // Si no coincide con ningun formato es invalido
			} else {
				nums = cNif.substring(0, cNif.length() - 1);
				ctrl = cNif.substring(cNif.length() - 1);
			}
		} else {
			tip = cNif.substring(1, 2);
			nums = cNif.substring(0, 1) + cNif.substring(2, cNif.length() - 1);
			ctrl = cNif.substring(cNif.length() - 1);
		}

		Integer check = 0;
		String check2 = '';
		if (tip != '') {
			if (Integer.valueOf(nums.substring(0, 1)) < 7) {
				return res;
			}
			nums = nums.substring(0, 1) + nums.substring(1).leftPad(5, '0');
			check = 2 * Integer.valueOf(nums.substring(0, 1));
			for (Integer i = 1; i < nums.length(); i++) {
				String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i,
								i + 1); // Digito del nif para cada iteracion
				check += (8 - i) * Integer.valueOf(num);
			}
		} else {
			if (Integer.valueOf(nums) == 0) {
				return res;
			}
			nums = nums.leftPad(7, '0');
			for (Integer i = 0; i < nums.length(); i++) {
				String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i,
								i + 1); // Digito del nif para cada iteracion
				check += (8 - i) * Integer.valueOf(num);
			}
		}
		check = Math.mod(check, 23);
		check2 = check == 'WABCDEFGHIJKLMNOPQRSTUV'.length() - 1 ? 'WABCDEFGHIJKLMNOPQRSTUV'.substring(
				check) : 'WABCDEFGHIJKLMNOPQRSTUV'.substring(check, check + 1);
		if (ctrl != check2) {
			return res;
		}

		res.result = 0;
		res.validatedNif = tip + nums + ctrl;
		return res;
	}

	public static ValidationResult isValidItaly(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico

		if (!Pattern.matches('(^[0-9]{1,10})([0-9]{1}$)', cNif)) {
			return res; // Si no coincide con ningun formato es invalido
		}

		String nums = cNif.substring(0, cNif.length() - 1);
		String ctrl = cNif.substring(cNif.length() - 1);

		nums = nums.leftPad(10, '0');

		if (Integer.valueOf(nums.substring(0, 7)) == 0) {
			return res;
		}
		Integer num7 = Integer.valueOf(nums.substring(7));
		if (num7 < 1 || num7 > 100 && num7 != 120 && num7 != 121) {
			return res;
		}

		Integer check = 0;
		String check2 = '';
		for (Integer i = 0; i < nums.length(); i++) {
			String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i, i + 1);
			String aux = Math.mod(i, 2) == 0 ? Integer.valueOf(num) * 1 + '0' :
						 Integer.valueOf(num) * 2 + '0'; // Multiplica los impares por 2
			check += Integer.valueOf(aux.substring(0, 1)) + Integer.valueOf(aux.substring(1, 2));
		}
		check = 10 - Math.mod(check, 10);
		check = check == 10 ? 0 : check;
		check2 = String.valueOf(check);
		if (ctrl != check2) {
			return res;
		}

		res.result = 0;
		res.validatedNif = nums + ctrl;
		return res;
	}

	public static ValidationResult isValidLithuania(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[0-9]{11})([0-9]{1}$)', cNif)) {
			if (!Pattern.matches('(^[0-9]{8})([0-9]{1}$)', cNif)) {
				return res; // Si no coincide con ningun formato es invalido
			}
		}

		String nums = cNif.substring(0, cNif.length() - 1);
		String ctrl = cNif.substring(cNif.length() - 1);
		if (nums.substring(nums.length() - 1) != '1') {
			return res;
		}

		list<Integer> CHG = new list <Integer>{1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 3, 4};

		Integer check = 0;
		String check2 = '';
		do {
			check = 0;
			for (Integer i = 0; i < nums.length(); i++) {
				String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i,
								i + 1); // Digito del nif para cada iteracion
				check += CHG[i] * Integer.valueOf(num) ;
			}
			if (CHG.size() < 13) {
				break;
			}
			CHG.remove(0);
			CHG.remove(0);
		} while (Math.mod(check, 11) == 10);
		check = Math.mod(check, 11);
		check = check == 10 ? 0 : check;
		check2 = String.valueOf(check);

		if (ctrl != check2) {
			return res;
		}

		res.result = 0;
		res.validatedNif = nums + ctrl;
		return res;
	}

	public static ValidationResult isValidLuxemburg(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[0-9]{1,6})([0-9]{2}$)', cNif)) {
			return res; // Si no coincide con ningun formato es invalido
		}

		String nums = cNif.substring(0, cNif.length() - 2);
		String ctrl = cNif.substring(cNif.length() - 2);

		nums = nums.leftPad(6, '0');

		String check2 = String.valueOf(Math.mod(Integer.valueOf(nums), 89)).leftPad(2, '0');
		if (ctrl != check2) {
			return res;
		}

		res.result = 0;
		res.validatedNif = nums + ctrl;
		return res;
	}

	public static ValidationResult isValidLatvia(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[4-9][0-9]{9})([0-9]{1}$)', cNif)) {
			if (!Pattern.matches('(^[0-3][0-9]{10})', cNif)) {
				return res; // Si no coincide con ningun formato es invalido
			}
		}

		String nums = cNif.substring(0, cNif.length() - 1);
		String ctrl = cNif.substring(cNif.length() - 1);

		if (Integer.valueOf(nums.substring(0, 1)) < 4) {
			if (Integer.valueOf(nums.substring(0, 2)) < 1) {
				return res;
			}
			if (Pattern.matches('02', nums.substring(2, 4))) {
				if (Math.mod(Integer.valueOf(nums.substring(4, 6)), 4) > 0) {
					if (Integer.valueOf(nums.substring(0, 2)) > 28) {
						return res;
					}
				} else if (Integer.valueOf(nums.substring(0, 2)) > 29) {
					return res;
				}
			} else if (Pattern.matches('04|06|09|11', nums.substring(2, 4))) {
				if (Integer.valueOf(nums.substring(0, 2)) > 30) {
					return res;
				}
			} else if (Integer.valueOf(nums.substring(0, 2)) > 31) {
				return res;
			}
			if (Integer.valueOf(nums.substring(2, 4)) < 1 || Integer.valueOf(nums.substring(2, 4)) > 12) {
				return res;
			}
		}

		Integer check = 0;
		if (Integer.valueOf(nums.substring(0, 1)) > 3) {
			list<Integer> CHG = new list <Integer>{9, 1, 4, 8, 3, 10, 2, 5, 7, 6};
			for (Integer i = 0; i < nums.length(); i++) {
				String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i,
								i + 1); // Digito del nif para cada iteracion
				check += CHG[i] * Integer.valueOf(num) ;
			}
			if (Math.mod(check, 11) == 4 && Integer.valueOf(nums.substring(0, 1)) == 9) {
				check = check - 45;
			}
			if (Math.mod(check, 11) == 4) {
				check = 4 - Math.mod(check, 11);
			} else if (Math.mod(check, 11) > 4) {
				check = 14 - Math.mod(check, 11);
			} else {
				check = 3 - Math.mod(check, 11);
			}
			String check2 = String.valueOf(check);
			if (ctrl != check2) {
				return res;
			}
		}

		res.result = 0;
		res.validatedNif = nums + ctrl;
		return res;
	}

	public static ValidationResult isValidMalta(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[0-9]{1,6})([0-9]{2}$)', cNif)) {
			return res; // Si no coincide con ningun formato es invalido
		}

		String nums = cNif.substring(0, cNif.length() - 2);
		String ctrl = cNif.substring(cNif.length() - 2);

		nums = nums.leftPad(6, '0');

		if (Integer.valueOf(nums) < 100001) {
			return res;
		}

		list<Integer> CHG = new list <Integer>{3, 4, 6, 7, 8, 9};
		Integer check = 0;
		for (Integer i = 0; i < nums.length(); i++) {
			String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i,
							i + 1); // Digito del nif para cada iteracion
			check += CHG[i] * Integer.valueOf(num) ;
		}
		String check2 = String.valueOf(37 - Math.mod(check, 37)).leftPad(2, '0');
		if (ctrl != check2) {
			return res;
		}

		res.result = 0;
		res.validatedNif = nums + ctrl;
		return res;
	}

	public static ValidationResult isValidNetherlands(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[0-9]{1,8})([0-9]{1})([B]{1})([0-9]{2}$)', cNif)) {
			return res; // Si no coincide con ningun formato es invalido
		}


		String nums = cNif.substring(0, cNif.length() - 4);
		String ctrl = cNif.substring(cNif.length() - 4, cNif.length() - 3);
		String tip = cNif.substring(cNif.length() - 3);

		if (Integer.valueOf(nums) == 0) {
			return res;
		}

		nums = nums.leftPad(8, '0');

		Integer check = 0;
		for (Integer i = 0; i < nums.length(); i++) {
			String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i,
							i + 1); // Digito del nif para cada iteracion
			check += (9 - i) * Integer.valueOf(num) ;
		}
		check = Math.mod(check, 11);
		if (check == 10) {
			return res;
		}
		String check2 = String.valueOf(check);
		if (ctrl != check2) {
			return res;
		}

		res.result = 0;
		res.validatedNif = nums + ctrl + tip;
		return res;
	}

	public static ValidationResult isValidPoland(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[0-9]{1,9})([0-9]{1}$)', cNif)) {
			return res; // Si no coincide con ningun formato es invalido
		}

		String nums = cNif.substring(0, cNif.length() - 1);
		String ctrl = cNif.substring(cNif.length() - 1);
		nums = nums.leftPad(9, '0');

		list<Integer> CHG = new list <Integer>{6, 5, 7, 2, 3, 4, 5, 6, 7};
		Integer check = 0;
		for (Integer i = 0; i < nums.length(); i++) {
			String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i,
							i + 1); // Digito del nif para cada iteracion
			check += CHG[i] * Integer.valueOf(num) ;
		}
		check = Math.mod(check, 11);
		if (check == 10) {
			return res;
		}
		String check2 = String.valueOf(check);
		if (ctrl != check2) {
			return res;
		}

		res.result = 0;
		res.validatedNif = nums + ctrl;
		return res;
	}

	public static ValidationResult isValidPortugal(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[0-9]{1,8})([0-9]{1}$)', cNif)) {
			return res; // Si no coincide con ningun formato es invalido
		}

		String nums = cNif.substring(0, cNif.length() - 1);
		String ctrl = cNif.substring(cNif.length() - 1);

		if (Integer.valueOf(nums.substring(0, 1)) < 1) {
			return res;
		}
		nums = nums.substring(0, 1) + nums.substring(1).leftPad(7, '0');

		Integer check = 0;
		for (Integer i = 0; i < nums.length(); i++) {
			String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i,
							i + 1); // Digito del nif para cada iteracion
			check += (9 - i) * Integer.valueOf(num) ;
		}
		check = 11 - Math.mod(check, 11);
		check = check > 9 ? 0 : check;
		String check2 = String.valueOf(check);
		if (ctrl != check2) {
			return res;
		}

		res.result = 0;
		res.validatedNif = nums + ctrl;
		return res;
	}

	public static ValidationResult isValidRomania(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[0-9]{1,9})([0-9]{1}$)', cNif)) {
			if (!Pattern.matches('(^[12346][0-9]{11})([0-9]{1}$)', cNif)) {
				return res; // Si no coincide con ningun formato es invalido
			}
		}

		String nums = cNif.substring(0, cNif.length() - 1);
		String ctrl = cNif.substring(cNif.length() - 1);

		Integer check = 0;
		String check2 = '';
		if (nums.length() == 12) {
			if (Integer.valueOf(nums.substring(3, 5)) < 1 || Integer.valueOf(nums.substring(3, 5)) > 12) {
				return res;
			}
			if (Pattern.matches('02', nums.substring(3, 5))) {
				if (Math.mod(Integer.valueOf(nums.substring(1, 3)), 4) > 0) {
					if (Integer.valueOf(nums.substring(5, 7)) > 28) {
						return res;
					}
				} else if (Integer.valueOf(nums.substring(5, 7)) > 29) {
					return res;
				}
			} else if (Pattern.matches('/04|06|09|11/', nums.substring(3, 5))) {
				if (Integer.valueOf(nums.substring(5, 7)) > 30) {
					return res;
				}
			} else {
				if (Integer.valueOf(nums.substring(5, 7)) > 31) {
					return res;
				}
			}
			list<Integer> CHG = new list <Integer>{2, 7, 9, 1, 4, 6, 3, 5, 8, 2, 7, 9};
			check = 0;
			for (Integer i = 0; i < nums.length(); i++) {
				String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i,
								i + 1); // Digito del nif para cada iteracion
				check += CHG[i] * Integer.valueOf(num) ;
			}
			check = Math.mod(check, 11);
			check = check == 10 ? 1 : check;
			check2 = String.valueOf(check);
			if (ctrl != check2) {
				return res;
			}

		} else {
			nums = nums.leftPad(9, '0');
			list<Integer> CHG = new list <Integer>{7, 5, 3, 2, 1, 7, 5, 3, 2};
			check = 0;
			for (Integer i = 0; i < nums.length(); i++) {
				String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i,
								i + 1); // Digito del nif para cada iteracion
				check += CHG[i] * Integer.valueOf(num) ;
			}
			check = Math.mod(check * 10, 11);
			check = check == 10 ? 0 : check;
			check2 = String.valueOf(check);
			if (ctrl != check2) {
				return res;
			}
		}

		res.result = 0;
		res.validatedNif = nums + ctrl;
		return res;
	}

	public static ValidationResult isValidSweden(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[0-9]{1,9})([0-9]{1})([0-9]{2}$)', cNif)) {
			return res; // Si no coincide con ningun formato es invalido
		}

		String nums = cNif.substring(0, cNif.length() - 3);
		String ctrl = cNif.substring(cNif.length() - 3, cNif.length() - 2);
		String tip = cNif.substring(cNif.length() - 2);

		if (Integer.valueOf(tip) == 0) {
			return res;
		}
		nums = nums.leftPad(9, '0');

		Integer check = 0;
		for (Integer i = 0; i < nums.length(); i++) {
			String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i,
							i + 1); // Digito del nif para cada iteracion
			String aux = Math.mod(i, 2) > 0 ? Integer.valueOf(num) * 1 + '0' :
						 Integer.valueOf(num) * 2 + '0'; // Multiplica los pares por 2
			check += Integer.valueOf(aux.substring(0, 1)) + Integer.valueOf(aux.substring(1, 2));
		}
		check = 10 - Math.mod(check, 10);
		check = check == 10 ? 0 : check;
		String check2 = String.valueOf(check);
		if (ctrl != check2) {
			return res;
		}

		res.result = 0;
		res.validatedNif = nums + ctrl + tip;
		return res;
	}

	public static ValidationResult isValidSlovenia(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[0-9]{1,7})([0-9]{1}$)', cNif)) {
			return res; // Si no coincide con ningun formato es invalido
		}

		String nums = cNif.substring(0, cNif.length() - 1);
		String ctrl = cNif.substring(cNif.length() - 1);
		nums = nums.leftPad(7, '0');

		if (Integer.valueOf(nums) < 1000000) {
			return res;
		}

		list<Integer> CHG = new list <Integer>{8, 7, 6, 5, 4, 3, 2};
		Integer check = 0;
		for (Integer i = 0; i < nums.length(); i++) {
			String num = i == nums.length() - 1 ? nums.substring(i) : nums.substring(i,
							i + 1); // Digito del nif para cada iteracion
			check += CHG[i] * Integer.valueOf(num) ;
		}

		check = 11 - Math.mod(check, 11);
		check = check == 10 ? 0 : check;
		check = check == 11 ? 1 : check;
		String check2 = String.valueOf(check);
		if (ctrl != check2) {
			return res;
		}

		res.result = 0;
		res.validatedNif = nums + ctrl;
		return res;
	}

	public static ValidationResult isValidSlovakia(String nif) {
		ValidationResult res = new ValidationResult();
		res.result = 1;
		res.validatedNif = '';

		String cNif = nif.replaceAll('[^0-9a-zA-Z]', ''); // Quitamos todo lo que no sea alfanumérico
		if (!Pattern.matches('(^[0-9]{10}$)', cNif)) {
			if (!Pattern.matches('(^[0-9]{9}$)', cNif)) {
				return res; // Si no coincide con ningun formato es invalido
			}
		}

		String nums = cNif;
		String ctrl = '';

		if (nums.length() == 9 || (
				Integer.valueOf(nums.substring(0, 2)) > 0 && Integer.valueOf(nums.substring(0, 2)) != 10 &&
						Integer.valueOf(nums.substring(0, 2)) != 20)) {
			if (nums.length() == 9) {
				if (Integer.valueOf(nums.substring(0, 2)) > 53) {
					return res;
				}
			} else {
				if (Integer.valueOf(nums.substring(0, 2)) < 54) {
					return res;
				}
			}
			if (Integer.valueOf(nums.substring(2, 4)) < 1 ||
							Integer.valueOf(nums.substring(2, 4)) > 12 && Integer.valueOf(nums.substring(2, 4)) < 51 ||
					Integer.valueOf(nums.substring(2, 4)) > 62) {
				return res;
			}
			if (Integer.valueOf(nums.substring(4, 6)) < 1) {
				return res;
			}
			if (Pattern.matches('02|52', nums.substring(2, 4))) {
				if (Math.mod(Integer.valueOf(nums.substring(0, 2)), 4) > 0) {
					if (Integer.valueOf(nums.substring(4, 6)) > 28) {
						return res;
					}
				} else {
					if (Integer.valueOf(nums.substring(4, 6)) > 29) {
						return res;
					}
				}
			} else if (Pattern.matches('04|06|09|11|54|56|59|61', nums.substring(2, 4))) {
				if (Integer.valueOf(nums.substring(4, 6)) > 30) {
					return res;
				}
			} else {
				if (Integer.valueOf(nums.substring(4, 6)) > 31) {
					return res;
				}
			}
		}

		res.result = 0;
		res.validatedNif = nums + ctrl;
		return res;
	}

	public static List<String> getAllEuCountries() {
		List<String> countries = new List<String>();
		countries.add('BE');
		countries.add('BG');
		countries.add('CY');
		countries.add('CZ');
		countries.add('DE');
		countries.add('DK');
		countries.add('ES');
		countries.add('HR');
		countries.add('EE');
		countries.add('FI');
		countries.add('FR');
		countries.add('GB');
		countries.add('EL');
		countries.add('HU');
		countries.add('IE');
		countries.add('IT');
		countries.add('LV');
		countries.add('LT');
		countries.add('LU');
		countries.add('MT');
		countries.add('NL');
		countries.add('PL');
		countries.add('PT');
		countries.add('RO');
		countries.add('SE');
		countries.add('SK');
		countries.add('SI');
		return countries;
	}

	public class ValidationResult {
		public Integer result;
		public String validatedNif;
	}
}