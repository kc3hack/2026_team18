// Project imports:
import 'package:mikata/models/account_manager.dart';

class PersonalityParameters {
//private member
    static final PersonalityParameters _instance = PersonalityParameters._internal();

    int _praise    = 0;
    int _empathy   = 0;
    int _criticism = 0;

// public method
    factory PersonalityParameters() => _instance;

    int get praise => _praise;
    set praise(int value) {
        _praise = value.clamp(0, 100);
    }

    int get empathy => _empathy;
    set empathy(int value) {
        _empathy = value.clamp(0, 100);
    }

    int get criticism => _criticism;
    set criticism(int value) {
        _criticism = value.clamp(0, 100);
    }

    List<int> getPersonalityCount() {
        _fetchParameters();
        
        final List<int> result = [];
        final sum = praise + empathy + criticism;

        if (sum == 0) {
            result[0] = (maxReplies / 3).toInt();
            result[1] = (maxReplies / 3).toInt();
            result[2] = (maxReplies / 3).toInt();
            return result;
        }

        double p = (praise / sum) * maxReplies;
        double e = (empathy / sum) * maxReplies;
        double c = (criticism / sum) * maxReplies;

        result[0] = p.toInt();
        result[1] = e.toInt();
        result[2] = c.toInt();
        return result;
    }

// private method
    PersonalityParameters._internal();

    void _fetchParameters() {
        // praise = ;
        // empathy = ;
        // criticism = ;
    }
}
