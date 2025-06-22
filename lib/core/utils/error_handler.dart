class ErrorHandler {
  static String getFirebaseAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return "Invalid email address.";
      case 'email-already-in-use':
        return "This email is already in use.";
      case 'operation-not-allowed':
        return "Email/password accounts are not enabled.";
      case 'weak-password':
        return "The password is too weak.";
      default:
        return "An authentication error occurred.";
    }
  }
}
