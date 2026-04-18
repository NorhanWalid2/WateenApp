abstract class HealthState {}

class HealthInitial extends HealthState {}

class HealthLoading extends HealthState {}

class HealthLoaded extends HealthState {
  final double systolic;
  final double diastolic;
  final double heartRate;
  final double sugar;

  HealthLoaded({
    required this.systolic,
    required this.diastolic,
    required this.heartRate,
    required this.sugar,
  });

  String get bloodPressure => '${systolic.toInt()}/${diastolic.toInt()}';
}

class HealthUpdating extends HealthState {
  final HealthLoaded previous;
  HealthUpdating(this.previous);
}

class HealthUpdateSuccess extends HealthState {
  final double systolic;
  final double diastolic;
  final double heartRate;
  final double sugar;

  HealthUpdateSuccess({
    required this.systolic,
    required this.diastolic,
    required this.heartRate,
    required this.sugar,
  });
}

class HealthError extends HealthState {
  final String message;
  HealthError(this.message);
}

// ── Helper to extract vitals from any state ───────────────────────────────────
extension HealthStateVitals on HealthState {
  double? get systolic {
    if (this is HealthLoaded) return (this as HealthLoaded).systolic;
    if (this is HealthUpdateSuccess)
      return (this as HealthUpdateSuccess).systolic;
    if (this is HealthUpdating)
      return (this as HealthUpdating).previous.systolic;
    return null;
  }

  double? get diastolic {
    if (this is HealthLoaded) return (this as HealthLoaded).diastolic;
    if (this is HealthUpdateSuccess)
      return (this as HealthUpdateSuccess).diastolic;
    if (this is HealthUpdating)
      return (this as HealthUpdating).previous.diastolic;
    return null;
  }

  double? get heartRate {
    if (this is HealthLoaded) return (this as HealthLoaded).heartRate;
    if (this is HealthUpdateSuccess)
      return (this as HealthUpdateSuccess).heartRate;
    if (this is HealthUpdating)
      return (this as HealthUpdating).previous.heartRate;
    return null;
  }

  double? get sugar {
    if (this is HealthLoaded) return (this as HealthLoaded).sugar;
    if (this is HealthUpdateSuccess) return (this as HealthUpdateSuccess).sugar;
    if (this is HealthUpdating) return (this as HealthUpdating).previous.sugar;
    return null;
  }

  bool get hasData =>
      this is HealthLoaded ||
      this is HealthUpdateSuccess ||
      this is HealthUpdating;
}
