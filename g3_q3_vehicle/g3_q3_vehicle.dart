abstract class Vehicle {
  String name;
  Vehicle(this.name);

  void start() => print('$name starts');   // shared code (inherited by extends)
  void honk();                              // abstract: subclasses MUST override
}

mixin Electric {
  int battery = 100;
  void charge() => print('Charging... battery at $battery%');
}

class Car extends Vehicle with Electric {
  Car() : super('Car');
  @override
  void honk() => print('Car: Beep beep');
}

class Motorcycle extends Vehicle {
  Motorcycle() : super('Motorcycle');
  @override
  void honk() => print('Motorcycle: Vroom');
}

// implements: no code is inherited, so EVERYTHING must be written again
class ToyVehicle implements Vehicle {
  @override
  String name = 'Toy';
  @override
  void start() => print('Toy rolls');
  @override
  void honk() => print('Toy: squeak');
}

void main() {
  final car = Car();
  car.start();
  car.honk();
  car.charge();
  Motorcycle().honk();
  ToyVehicle().start();
}
