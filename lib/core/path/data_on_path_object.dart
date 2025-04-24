import 'package:firefast/firefast_core.dart';

abstract class DataOnPathObject<O>
    implements
        ReadNoParams<O>,
        WriteNoParams,
        OverwriteNoParams,
        DeleteNoParams {}
