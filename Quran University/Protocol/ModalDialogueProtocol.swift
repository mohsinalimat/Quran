import Foundation

@objc protocol ModalDialogueProtocol {
    func onDoneHandler(Id: Int64)
    @objc optional func onDoneHandler(PriId: Int64, SecId: Int64)
    @objc optional func onDoneHandler(StartSurahId: Int64, EndSurahId: Int64, StartAyatOrderId: Int64, EndAyatOrderId: Int64, AyatRecitationSilence: Double, AyatRepeatFor: Int64)
    @objc optional func onCancelHandler()
}
