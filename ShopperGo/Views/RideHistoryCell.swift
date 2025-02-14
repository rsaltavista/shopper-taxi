//
//  RideHistoryCell.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 14/02/25.
//

import SwiftUI

struct RideHistoryCell: View {
    var ride: RideRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(getDriverImageName(for: ride.driver.name))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    .padding(.trailing, 10)

                VStack(alignment: .leading, spacing: 5) {
                    Text(ride.driver.name)
                        .font(.headline)
                        .foregroundColor(.black)

                    Text("📅 \(formatDate(ride.date))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 4) {
                RideInfoRow(icon: "mappin.and.ellipse", text: "Origem: \(ride.origin)")
                RideInfoRow(icon: "location.fill", text: "Destino: \(ride.destination)")
                RideInfoRow(icon: "ruler.fill", text: "Distância: \(formatDistance(ride.distance)) km")
                RideInfoRow(icon: "clock.fill", text: formatDuration(ride.duration))
                RideInfoRow(icon: "creditcard.fill", text: "Valor: \(formatPrice(ride.value))", color: .green)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }

    private func formatDate(_ isoDate: String) -> String {
        let cleanedDate = isoDate.trimmingCharacters(in: .whitespacesAndNewlines)
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")

        if let date = inputFormatter.date(from: cleanedDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd 'de' MMMM 'de' yyyy, HH:mm"
            outputFormatter.locale = Locale(identifier: "pt_BR")
            return outputFormatter.string(from: date)
        }
        return "Data inválida"
    }

    private func formatDuration(_ duration: Any) -> String {
        print("Valor recebido de duration: \(duration)")

        if let durationDouble = duration as? Double {
            let durationInt = Int(durationDouble)
            return "\(durationInt / 60) minutos"
        } else if let durationInt = duration as? Int {
            return "\(durationInt / 60) minutos"
        } else if let durationString = duration as? String {
            let components = durationString.split(separator: ":")
            if components.count == 2,
               let minutes = Int(components[0]),
               let seconds = Int(components[1]) {
                let totalMinutes = minutes + (seconds >= 30 ? 1 : 0)
                return "\(totalMinutes) minutos"
            }
        }

        return "Duração indisponível"
    }

    private func formatDistance(_ distance: Double) -> String {
        return String(format: "%.2f", distance)
    }

    private func formatPrice(_ price: Double) -> String {
        return "R$ \(String(format: "%.2f", price))"
    }

    private func getDriverImageName(for driverName: String) -> String {
        switch driverName.lowercased() {
        case "homer simpson": return "homersimpson"
        case "dominic toretto": return "dominictoretto"
        case "james bond": return "jamesbond"
        default: return "defaultdriver"
        }
    }
}
