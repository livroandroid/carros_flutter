import 'package:rxdart/rxdart.dart';

EventBus eventBus = EventBus();

class EventBus {

  final _controller = PublishSubject<dynamic>();

  get stream => _controller.stream;

  post(dynamic event) {
    _controller.sink.add(event);
  }

  void close() {
    _controller.close();
  }
}