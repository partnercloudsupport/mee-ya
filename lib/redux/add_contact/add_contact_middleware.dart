import 'package:medical_app/data/network/contact_repository.dart';
import 'package:medical_app/redux/add_contact/contact_action.dart';
import 'package:medical_app/redux/app/app_state.dart';
import 'package:medical_app/redux/contract/contact_action.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createAddContactMiddleware(
  ContractRepository contractRepository,
) {
  return [
    new TypedMiddleware<AppState, AddContactAction>(addContact(contractRepository)),
    new TypedMiddleware<AppState, EditContactAction>(editContact(contractRepository)),
    new TypedMiddleware<AppState, DeleteContactAction>(deleteContact(contractRepository)),
  ];
}

Middleware<AppState> addContact(
  ContractRepository contractRepository,
) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is AddContactAction) {
      next(RequestAddContactAction());

      try {
        final token = store.state.token;
        await contractRepository.addContact(action.contact, token);
        action.completer.complete(null);

        next(SuccessAddContactAction());
        next(FetchContacts());
      } catch (error) {
        next(ErrorAddContactAction());
        print(error);
      }

      next(action);
    }
  };
}

Middleware<AppState> editContact(
  ContractRepository contractRepository,
) {
  return (Store store, action, NextDispatcher next) async {
    if (action is EditContactAction) {
      next(RequestEditContactAction());

      try {
        final token = store.state.token;
        await contractRepository.updateContact(token, action.contact);

        next(SuccessEditContactAction());
        next(FetchContacts());

        action.completer.complete(null);
      } catch (error) {
        action.completer.completeError(error);
      }

      next(action);
    }
  };
}

Middleware<AppState> deleteContact(
  ContractRepository contractRepository,
) {
  return (Store store, action, NextDispatcher next) async {
    if (action is DeleteContactAction) {
      try {
        final token = store.state.token;
        await contractRepository.deleteContact(token, action.contact.id);

        store.dispatch(FetchContacts());
        action.completer.complete(null);
      } catch (error) {
        action.completer.completeError(error);
      }
      next(action);
    }
  };
}
