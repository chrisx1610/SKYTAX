/// Textos de la interfaz en español e inglés.
///
/// Se usa una clase inmutable con dos instancias constantes ([es] y [en]);
/// las pantallas obtienen la instancia activa desde el estado global.
class AppStrings {
  const AppStrings({
    required this.localeCode,
    required this.appTagline,
    required this.continueLabel,
    required this.cancel,
    required this.back,
    required this.close,
    required this.save,
    required this.delete,
    required this.edit,
    required this.add,
    required this.confirm,
    required this.finish,
    required this.retry,
    required this.requiredField,
    required this.errorGeneric,
    required this.selectLanguage,
    required this.welcomeTouch,
    required this.consultTitle,
    required this.consultSubtitle,
    required this.registrationLabel,
    required this.aircraftTypeLabel,
    required this.passengersLabel,
    required this.consult,
    required this.history,
    required this.adminPanel,
    required this.enterRegistration,
    required this.enterAircraftType,
    required this.invalidPassengers,
    required this.summaryTitle,
    required this.registrationShort,
    required this.modelLabel,
    required this.passengersShort,
    required this.airportTaxLabel,
    required this.dosaLabel,
    required this.totalToPay,
    required this.localAircraftNote,
    required this.foreignAircraftNote,
    required this.paymentTitle,
    required this.methodCard,
    required this.methodMobile,
    required this.cardProcessingTitle,
    required this.insertCard,
    required this.stepValidating,
    required this.stepAuthorizing,
    required this.stepApproved,
    required this.mobileInstructions,
    required this.bankLabel,
    required this.phoneLabel,
    required this.rifLabel,
    required this.amountLabel,
    required this.referenceLabel,
    required this.referenceHint,
    required this.confirmPayment,
    required this.verifyingPayment,
    required this.invalidReference,
    required this.paymentReceived,
    required this.confirmationTitle,
    required this.invoiceNumberLabel,
    required this.dateLabel,
    required this.timeLabel,
    required this.paymentMethodLabel,
    required this.totalPaidLabel,
    required this.invoiceGenerated,
    required this.viewInvoice,
    required this.newOperation,
    required this.airportLabel,
    required this.operatorLabel,
    required this.subtotalLabel,
    required this.totalPaidUpper,
    required this.invoiceThanks,
    required this.notRegistered,
    required this.historyTitle,
    required this.searchHint,
    required this.noInvoices,
    required this.openFolder,
    required this.fileMissing,
    required this.adminLoginTitle,
    required this.usernameLabel,
    required this.passwordLabel,
    required this.login,
    required this.logout,
    required this.invalidCredentials,
    required this.adminTitle,
    required this.sectionAircraft,
    required this.sectionOperators,
    required this.sectionUsers,
    required this.sectionSettings,
    required this.sectionHistory,
    required this.sectionReports,
    required this.sectionAudit,
    required this.newAircraft,
    required this.editAircraft,
    required this.modelField,
    required this.operatorField,
    required this.capacityField,
    required this.registrationExists,
    required this.newOperator,
    required this.editOperator,
    required this.nameField,
    required this.rifField,
    required this.newUser,
    required this.editUser,
    required this.singleAdminNote,
    required this.fullNameField,
    required this.roleField,
    required this.roleAdmin,
    required this.roleOperator,
    required this.passwordKeepHint,
    required this.usernameExists,
    required this.cannotDeleteSelf,
    required this.taxRateField,
    required this.dosaField,
    required this.airportCodeField,
    required this.airportNameField,
    required this.settingsSaved,
    required this.invalidNumber,
    required this.airportChangedNote,
    required this.periodToday,
    required this.period7Days,
    required this.periodAll,
    required this.statInvoices,
    required this.statTotal,
    required this.statByMethod,
    required this.generateReport,
    required this.reportGenerated,
    required this.colDate,
    required this.colUser,
    required this.colAction,
    required this.colDetails,
    required this.noRecords,
    required this.deleteConfirmTemplate,
  });

  final String localeCode;

  // Generales
  final String appTagline;
  final String continueLabel;
  final String cancel;
  final String back;
  final String close;
  final String save;
  final String delete;
  final String edit;
  final String add;
  final String confirm;
  final String finish;
  final String retry;
  final String requiredField;
  final String errorGeneric;

  // Idioma
  final String selectLanguage;
  final String welcomeTouch;

  // Menú principal / consulta
  final String consultTitle;
  final String consultSubtitle;
  final String registrationLabel;
  final String aircraftTypeLabel;
  final String passengersLabel;
  final String consult;
  final String history;
  final String adminPanel;
  final String enterRegistration;
  final String enterAircraftType;
  final String invalidPassengers;

  // Resumen
  final String summaryTitle;
  final String registrationShort;
  final String modelLabel;
  final String passengersShort;
  final String airportTaxLabel;
  final String dosaLabel;
  final String totalToPay;
  final String localAircraftNote;
  final String foreignAircraftNote;

  // Pago
  final String paymentTitle;
  final String methodCard;
  final String methodMobile;
  final String cardProcessingTitle;
  final String insertCard;
  final String stepValidating;
  final String stepAuthorizing;
  final String stepApproved;
  final String mobileInstructions;
  final String bankLabel;
  final String phoneLabel;
  final String rifLabel;
  final String amountLabel;
  final String referenceLabel;
  final String referenceHint;
  final String confirmPayment;
  final String verifyingPayment;
  final String invalidReference;
  final String paymentReceived;

  // Confirmación
  final String confirmationTitle;
  final String invoiceNumberLabel;
  final String dateLabel;
  final String timeLabel;
  final String paymentMethodLabel;
  final String totalPaidLabel;
  final String invoiceGenerated;
  final String viewInvoice;
  final String newOperation;

  // Factura TXT
  final String airportLabel;
  final String operatorLabel;
  final String subtotalLabel;
  final String totalPaidUpper;
  final String invoiceThanks;
  final String notRegistered;

  // Historial
  final String historyTitle;
  final String searchHint;
  final String noInvoices;
  final String openFolder;
  final String fileMissing;

  // Administración
  final String adminLoginTitle;
  final String usernameLabel;
  final String passwordLabel;
  final String login;
  final String logout;
  final String invalidCredentials;
  final String adminTitle;
  final String sectionAircraft;
  final String sectionOperators;
  final String sectionUsers;
  final String sectionSettings;
  final String sectionHistory;
  final String sectionReports;
  final String sectionAudit;
  final String newAircraft;
  final String editAircraft;
  final String modelField;
  final String operatorField;
  final String capacityField;
  final String registrationExists;
  final String newOperator;
  final String editOperator;
  final String nameField;
  final String rifField;
  final String newUser;
  final String editUser;
  final String singleAdminNote;
  final String fullNameField;
  final String roleField;
  final String roleAdmin;
  final String roleOperator;
  final String passwordKeepHint;
  final String usernameExists;
  final String cannotDeleteSelf;
  final String taxRateField;
  final String dosaField;
  final String airportCodeField;
  final String airportNameField;
  final String settingsSaved;
  final String invalidNumber;
  final String airportChangedNote;

  // Reportes
  final String periodToday;
  final String period7Days;
  final String periodAll;
  final String statInvoices;
  final String statTotal;
  final String statByMethod;
  final String generateReport;
  final String reportGenerated;

  // Auditoría
  final String colDate;
  final String colUser;
  final String colAction;
  final String colDetails;
  final String noRecords;

  final String deleteConfirmTemplate;

  String confirmDelete(String item) =>
      deleteConfirmTemplate.replaceFirst('%s', item);

  String paymentMethodName(String code) =>
      code == 'mobile' ? methodMobile : methodCard;

  String roleName(String role) => role == 'admin' ? roleAdmin : roleOperator;

  static const AppStrings es = AppStrings(
    localeCode: 'es',
    appTagline: 'Sistema de Pago de Impuestos Aeroportuarios',
    continueLabel: 'Continuar',
    cancel: 'Cancelar',
    back: 'Volver',
    close: 'Cerrar',
    save: 'Guardar',
    delete: 'Eliminar',
    edit: 'Editar',
    add: 'Agregar',
    confirm: 'Confirmar',
    finish: 'Finalizar',
    retry: 'Reintentar',
    requiredField: 'Campo obligatorio',
    errorGeneric: 'Ocurrió un error inesperado. Intente nuevamente.',
    selectLanguage: 'Seleccione el idioma',
    welcomeTouch: 'Bienvenido · Welcome',
    consultTitle: 'Datos de la aeronave',
    consultSubtitle:
        'Ingrese los datos del vuelo para calcular los impuestos de forma automática.',
    registrationLabel: 'Matrícula de la aeronave',
    aircraftTypeLabel: 'Tipo de aeronave',
    passengersLabel: 'Cantidad de pasajeros',
    consult: 'Siguiente',
    history: 'Historial',
    adminPanel: 'Panel administrativo',
    enterRegistration: 'Ingrese la matrícula de la aeronave',
    enterAircraftType: 'Ingrese el tipo de aeronave',
    invalidPassengers: 'Ingrese una cantidad de pasajeros válida',
    summaryTitle: 'Resumen',
    registrationShort: 'Matrícula',
    modelLabel: 'Modelo',
    passengersShort: 'Cantidad de pasajeros',
    airportTaxLabel: 'Tasa aeroportuaria',
    dosaLabel: 'DOSA',
    totalToPay: 'Total a pagar',
    localAircraftNote: 'Aeronave con base en este aeropuerto.',
    foreignAircraftNote:
        'Aeronave de otro aeropuerto. Se aplica DOSA automáticamente.',
    paymentTitle: 'Seleccione el método de pago',
    methodCard: 'Tarjeta',
    methodMobile: 'Pago Móvil',
    cardProcessingTitle: 'Pago con Tarjeta',
    insertCard: 'Inserte o acerque la tarjeta al lector',
    stepValidating: 'Validando tarjeta...',
    stepAuthorizing: 'Autorizando pago...',
    stepApproved: 'Pago aprobado',
    mobileInstructions:
        'Realice el pago móvil con los siguientes datos y luego ingrese el número de referencia de la operación.',
    bankLabel: 'Banco',
    phoneLabel: 'Teléfono',
    rifLabel: 'RIF',
    amountLabel: 'Monto',
    referenceLabel: 'Número de referencia',
    referenceHint: 'Ej: 00123456',
    confirmPayment: 'Confirmar pago',
    verifyingPayment: 'Verificando pago...',
    invalidReference:
        'Ingrese un número de referencia válido (mínimo 6 dígitos)',
    paymentReceived: 'Pago recibido correctamente.',
    confirmationTitle: 'Confirmación',
    invoiceNumberLabel: 'Número de factura',
    dateLabel: 'Fecha',
    timeLabel: 'Hora',
    paymentMethodLabel: 'Método de pago',
    totalPaidLabel: 'Total cancelado',
    invoiceGenerated: 'Factura generada correctamente.',
    viewInvoice: 'Ver factura',
    newOperation: 'Finalizar',
    airportLabel: 'Aeropuerto',
    operatorLabel: 'Operador',
    subtotalLabel: 'Subtotal',
    totalPaidUpper: 'TOTAL PAGADO',
    invoiceThanks: 'Gracias por utilizar SkyTax',
    notRegistered: 'No registrado',
    historyTitle: 'Historial de facturas',
    searchHint: 'Buscar por matrícula o número de factura',
    noInvoices: 'No hay facturas registradas.',
    openFolder: 'Abrir carpeta',
    fileMissing: 'El archivo de la factura no se encontró en el disco.',
    adminLoginTitle: 'Acceso administrativo',
    usernameLabel: 'Usuario',
    passwordLabel: 'Contraseña',
    login: 'Ingresar',
    logout: 'Cerrar sesión',
    invalidCredentials: 'Usuario o contraseña incorrectos',
    adminTitle: 'Panel administrativo',
    sectionAircraft: 'Aeronaves',
    sectionOperators: 'Operadores',
    sectionUsers: 'Usuarios',
    sectionSettings: 'Configuración',
    sectionHistory: 'Historial',
    sectionReports: 'Reportes',
    sectionAudit: 'Auditoría',
    newAircraft: 'Nueva aeronave',
    editAircraft: 'Editar aeronave',
    modelField: 'Modelo / Tipo',
    operatorField: 'Operador',
    capacityField: 'Capacidad (opcional)',
    registrationExists: 'Ya existe una aeronave con esa matrícula',
    newOperator: 'Nuevo operador',
    editOperator: 'Editar operador',
    nameField: 'Nombre',
    rifField: 'RIF (opcional)',
    newUser: 'Nuevo usuario',
    editUser: 'Editar usuario',
    singleAdminNote:
        'El sistema utiliza un único usuario administrador. Aquí puede cambiar su nombre y su contraseña.',
    fullNameField: 'Nombre completo',
    roleField: 'Rol',
    roleAdmin: 'Administrador',
    roleOperator: 'Operador',
    passwordKeepHint: 'Dejar en blanco para mantener la contraseña actual',
    usernameExists: 'Ya existe un usuario con ese nombre',
    cannotDeleteSelf: 'No puede eliminar su propio usuario',
    taxRateField: 'Tasa aeroportuaria (EUR por pasajero)',
    dosaField: 'DOSA (EUR)',
    airportCodeField: 'Código OACI del aeropuerto',
    airportNameField: 'Nombre del aeropuerto',
    settingsSaved: 'Configuración guardada correctamente',
    invalidNumber: 'Ingrese un valor numérico válido',
    airportChangedNote:
        'Cada aeropuerto usa su propia base de datos. Al cambiar el código se abrirá (o creará) la base de datos de ese aeropuerto.',
    periodToday: 'Hoy',
    period7Days: 'Últimos 7 días',
    periodAll: 'Todo',
    statInvoices: 'Facturas emitidas',
    statTotal: 'Total recaudado',
    statByMethod: 'Por método de pago',
    generateReport: 'Generar reporte TXT',
    reportGenerated: 'Reporte generado:',
    colDate: 'Fecha',
    colUser: 'Usuario',
    colAction: 'Acción',
    colDetails: 'Detalle',
    noRecords: 'No hay registros.',
    deleteConfirmTemplate: '¿Desea eliminar "%s"? Esta acción no se puede deshacer.',
  );

  static const AppStrings en = AppStrings(
    localeCode: 'en',
    appTagline: 'Airport Tax Payment System',
    continueLabel: 'Continue',
    cancel: 'Cancel',
    back: 'Back',
    close: 'Close',
    save: 'Save',
    delete: 'Delete',
    edit: 'Edit',
    add: 'Add',
    confirm: 'Confirm',
    finish: 'Finish',
    retry: 'Retry',
    requiredField: 'Required field',
    errorGeneric: 'An unexpected error occurred. Please try again.',
    selectLanguage: 'Select your language',
    welcomeTouch: 'Bienvenido · Welcome',
    consultTitle: 'Aircraft details',
    consultSubtitle:
        'Enter the flight details to calculate the taxes automatically.',
    registrationLabel: 'Aircraft registration',
    aircraftTypeLabel: 'Aircraft type',
    passengersLabel: 'Number of passengers',
    consult: 'Next',
    history: 'History',
    adminPanel: 'Admin panel',
    enterRegistration: 'Enter the aircraft registration',
    enterAircraftType: 'Enter the aircraft type',
    invalidPassengers: 'Enter a valid number of passengers',
    summaryTitle: 'Summary',
    registrationShort: 'Registration',
    modelLabel: 'Model',
    passengersShort: 'Passengers',
    airportTaxLabel: 'Airport tax',
    dosaLabel: 'DOSA',
    totalToPay: 'Total to pay',
    localAircraftNote: 'Aircraft based at this airport.',
    foreignAircraftNote:
        'Aircraft from another airport. DOSA is applied automatically.',
    paymentTitle: 'Select the payment method',
    methodCard: 'Card',
    methodMobile: 'Mobile Payment',
    cardProcessingTitle: 'Card Payment',
    insertCard: 'Insert or tap your card on the reader',
    stepValidating: 'Validating card...',
    stepAuthorizing: 'Authorizing payment...',
    stepApproved: 'Payment approved',
    mobileInstructions:
        'Make the mobile payment using the following details, then enter the transaction reference number.',
    bankLabel: 'Bank',
    phoneLabel: 'Phone',
    rifLabel: 'Tax ID (RIF)',
    amountLabel: 'Amount',
    referenceLabel: 'Reference number',
    referenceHint: 'E.g. 00123456',
    confirmPayment: 'Confirm payment',
    verifyingPayment: 'Verifying payment...',
    invalidReference: 'Enter a valid reference number (at least 6 digits)',
    paymentReceived: 'Payment received successfully.',
    confirmationTitle: 'Confirmation',
    invoiceNumberLabel: 'Invoice number',
    dateLabel: 'Date',
    timeLabel: 'Time',
    paymentMethodLabel: 'Payment method',
    totalPaidLabel: 'Total paid',
    invoiceGenerated: 'Invoice generated successfully.',
    viewInvoice: 'View invoice',
    newOperation: 'Finish',
    airportLabel: 'Airport',
    operatorLabel: 'Operator',
    subtotalLabel: 'Subtotal',
    totalPaidUpper: 'TOTAL PAID',
    invoiceThanks: 'Thank you for using SkyTax',
    notRegistered: 'Not registered',
    historyTitle: 'Invoice history',
    searchHint: 'Search by registration or invoice number',
    noInvoices: 'No invoices recorded.',
    openFolder: 'Open folder',
    fileMissing: 'The invoice file was not found on disk.',
    adminLoginTitle: 'Admin access',
    usernameLabel: 'Username',
    passwordLabel: 'Password',
    login: 'Sign in',
    logout: 'Sign out',
    invalidCredentials: 'Incorrect username or password',
    adminTitle: 'Admin panel',
    sectionAircraft: 'Aircraft',
    sectionOperators: 'Operators',
    sectionUsers: 'Users',
    sectionSettings: 'Settings',
    sectionHistory: 'History',
    sectionReports: 'Reports',
    sectionAudit: 'Audit log',
    newAircraft: 'New aircraft',
    editAircraft: 'Edit aircraft',
    modelField: 'Model / Type',
    operatorField: 'Operator',
    capacityField: 'Capacity (optional)',
    registrationExists: 'An aircraft with that registration already exists',
    newOperator: 'New operator',
    editOperator: 'Edit operator',
    nameField: 'Name',
    rifField: 'Tax ID (optional)',
    newUser: 'New user',
    editUser: 'Edit user',
    singleAdminNote:
        'The system uses a single administrator account. Here you can change its name and password.',
    fullNameField: 'Full name',
    roleField: 'Role',
    roleAdmin: 'Administrator',
    roleOperator: 'Operator',
    passwordKeepHint: 'Leave blank to keep the current password',
    usernameExists: 'A user with that username already exists',
    cannotDeleteSelf: 'You cannot delete your own user',
    taxRateField: 'Airport tax (EUR per passenger)',
    dosaField: 'DOSA (EUR)',
    airportCodeField: 'Airport ICAO code',
    airportNameField: 'Airport name',
    settingsSaved: 'Settings saved successfully',
    invalidNumber: 'Enter a valid numeric value',
    airportChangedNote:
        'Each airport uses its own database. Changing the code will open (or create) that airport\'s database.',
    periodToday: 'Today',
    period7Days: 'Last 7 days',
    periodAll: 'All time',
    statInvoices: 'Invoices issued',
    statTotal: 'Total collected',
    statByMethod: 'By payment method',
    generateReport: 'Generate TXT report',
    reportGenerated: 'Report generated:',
    colDate: 'Date',
    colUser: 'User',
    colAction: 'Action',
    colDetails: 'Details',
    noRecords: 'No records.',
    deleteConfirmTemplate: 'Delete "%s"? This action cannot be undone.',
  );
}
