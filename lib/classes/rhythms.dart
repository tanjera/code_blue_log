import 'package:flutter/material.dart';

import '../models/rhythm.dart';

class Rhythms {
  List<Rhythm> list = [
    Rhythm("Asystole", Colors.red),
    Rhythm("Atrial Fibrillation", null),
    Rhythm("Atrial Flutter", null),
    Rhythm("1° Atrioventricular Block", null),
    Rhythm("2° Atrioventricular Block, Mobitz II", null),
    Rhythm("2° Atrioventricular Block, Wenckebach", null),
    Rhythm("3° Atrioventricular Block", null),
    Rhythm("Bundle Branch Block", null),
    Rhythm("Idioventricular", null),
    Rhythm("Junctional", null),
    Rhythm("Pulseless Electrical Activity (PEA)", Colors.red),
    Rhythm("Sick Sinus Syndrome", null),
    Rhythm("Sinus Arrhythmia", null),
    Rhythm("Sinus Rhythm", Colors.green),
    Rhythm("Sinus Rhythm with Sinoatrial arrest", null),
    Rhythm("Sinus rhythm with Bigeminy", null),
    Rhythm("Sinus rhythm with Trigeminy", null),
    Rhythm("Sinus rhythm with PAC", null),
    Rhythm("Sinus rhythm with PJC", null),
    Rhythm("Sinus rhythm with PVC", null),
    Rhythm("Supraventricular Tachycardia", null),
    Rhythm("Ventricular Fibrillation (VF)", Colors.red),
    Rhythm("Ventricular Standstill", null),
    Rhythm("Ventricular Tachycardia (VT)", Colors.red),
    Rhythm("Ventricular Tachycardia (VT), Monomorphic", null),
    Rhythm("Ventricular Tachycardia (VT), Polymorphic", null)
  ];

  Rhythms () {
    // In case they are out of alphabetical order in the declaring list...
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}
