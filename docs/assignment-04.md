# Asgn-04 — Service Objects (Appointments)

This guide shows the **steps and Rails commands** to create the files and wiring for the requested architecture.

## 0) Go to the Rails app

```bash
cd /Users/apple/Desktop/ILA/Backend
```

## 1) Generate the model (Appointment)

> If your schema already exists, adjust the fields or skip this step.

```bash
bin/rails g model Appointment starts_at:datetime ends_at:datetime
```

## 2) Generate the controller (AppointmentsController)

```bash
bin/rails g controller appointments create
```

## 3) Generate the service object

```bash
mkdir -p app/services/appointments
touch app/services/appointments/create.rb
```

## 4) Edit the generated files (high-level checklist)

- `app/controllers/appointments_controller.rb`
  - Keep it thin: parse params + call the service + render the result.
- `app/services/appointments/create.rb`
  - Encapsulate booking rules and overlap checks.
  - Return a consistent Result object (success? + data/errors).
- `app/models/appointment.rb`
  - Put domain invariants and reusable overlap scopes here.

## 5) Run the migrations

```bsh
bin/rails db:migrate
bin/rails db:schema:dump
```

## 6) Quick verification

```bash
bin/rails routes | grep appointments
```

## 7) Testing

### Create a test Apoointment

```bsh
backend(dev)* result = Appointments::Create.new(
backend(dev)*   starts_at: Time.now,
backend(dev)*   ends_at: Time.now + 1.hour
backend(dev)> ).call
```

### Create a conflicting Appointment

```bsh
backend(dev)* result = Appointments::Create.new(
backend(dev)*   starts_at: Time.now + 30.minutes,
backend(dev)*   ends_at: Time.now + 90.minutes
backend(dev)> ).call
```

### Delete the test records

```bsh
Appointment.destroy_all
Appointment.count
```

## Expected structure

```md
app/
 ├── controllers/
 │     └── appointments_controller.rb
 │
 ├── services/
 │     └── appointments/
 │            └── create.rb
 │
 └── models/
       └── appointment.rb
```

## Notes

- Business logic belongs in the service/model, not in the controller.
- Keep the Result object consistent across success/failure.
- Overlap checks should be deterministic and centralized (model or service).
