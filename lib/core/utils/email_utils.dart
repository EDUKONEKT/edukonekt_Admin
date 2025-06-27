String generateEmailFromName(String fullName) {
  final parts = fullName.trim().toLowerCase().split(RegExp(r'\s+'));
  if (parts.length == 1) return '${parts.first}@edukonekt.com';
  return '${parts.first}.${parts.last}@edukonekt.com';
}
