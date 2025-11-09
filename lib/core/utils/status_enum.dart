enum Status { angry, happy, sad, normal, smile }

Status stringToStatus(String status) {
  return switch (status) {
    'normal' => Status.normal,
    'sad' => Status.sad,
    'angry' => Status.angry,
    'happy' => Status.happy,
    _ => Status.smile,
  };
}
