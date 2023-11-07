/// An interface of persistence stores for the player's progress.
///
/// Implementations can range from simple in-memory storage through
/// local preferences to cloud saves.
abstract class PlayerProgressPersistence {
  Future<List<int>> getFinishedLevels();

  Future<void> saveLevelFinished(int level, int time);

  Future<void> reset();
}
