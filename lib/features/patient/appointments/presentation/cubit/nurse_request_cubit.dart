import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/patient/appointments/presentation/cubit/nurse_request_state.dart';
import '../../data/models/nurse_request_model.dart';

class NurseRequestsCubit extends Cubit<NurseRequestsState> {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "http://wateen.runasp.net"),
  );

  NurseRequestsCubit() : super(NurseRequestsInitial());

  Future<void> fetchRequests() async {
    emit(NurseRequestsLoading());
    try {
      final response = await _dio.get(
        "/api/HomeService/PatientRequests",
        options: Options(
          headers: {"Authorization": "Bearer ${AppPrefs.token}"},
        ),
      );
      final List data = response.data as List;
      final requests =
          data.map((e) => NurseRequestModel.fromJson(e)).toList();
      emit(NurseRequestsLoaded(requests));
    } on DioException catch (e) {
      emit(NurseRequestsError(
        e.response?.data?['message'] ?? 'Failed to load requests',
      ));
    } catch (_) {
      emit(NurseRequestsError('Something went wrong'));
    }
  }
}