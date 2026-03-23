# 🛡️ Hardware Check-up: D-Link DGS-1510-52

Voordat de switch de imaging-kar in gaat, doorloop je deze stappen. Dit voorkomt vage netwerkfouten tijdens het flashen van de 10 desktops.

---

## 1. Fysieke Inspectie (Stof & Fans)
De SFP+ poorten (51/52) produceren veel hitte bij 10 Gbps. De interne koeling moet 100% zijn.
* **Actie:** Zet de switch aan en luister naar de ventilatoren. 
* **Check:** Geen ratelend of zingend geluid? Komt er lucht uit de roosters?
* **Schoonmaken:** Gebruik perslucht bij zichtbaar stof in de koelkanalen.

## 2. Loopback Zelftest (1 Gbps Poorten)
Controleer of de centrale switching-chip pakketjes kan routeren.
* **Actie:** Prik een korte netwerkkabel in **Poort 1** en de andere kant in **Poort 2**.
* **Resultaat:** De lampjes van beide poorten moeten groen gaan knipperen.
* **Herhaling:** Doe dit willekeurig bij een paar van de 48 poorten om de chip te testen.

## 3. SFP+ Slot Check (De 20G Backbone)
Dit is het meest kritieke onderdeel voor je €47,22 setup.
* **Actie:** Pak de twee **SFP-naar-RJ45 converters** uit je deal.
* **Stap A:** Prik ze in **Poort 51** en **Poort 52**.
* **Stap B:** Verbind 51 en 52 met elkaar via een normale netwerkkabel.
* **Resultaat:** De link-lampjes boven de SFP-slots moeten aangaan.
* **Betekenis:** De SFP-slots geven stroom en herkennen data. De poorten zijn fysiek in orde.

## 4. Software & Error Check (CLI)
Log in via SSH of de console-kabel om de "gezondheid" van de poorten uit te lezen.
* **Commando voor fouten:** `show error inline-ports`
* **Commando voor statistieken:**
  `show statistics interface ethernet 1/0/51`
* **Check:** Zoek naar **CRC Errors**. Dit moet op `0` staan. Een hoog getal betekent een defecte poort of een slechte kabel/converter.

## 5. Fabrieksinstellingen (Hard Reset)
Verwijder oude configuraties (VLANs, ACLs) die je script in de weg kunnen zitten.
* **Actie:** Houd de fysieke **Reset-knop** aan de voorzijde 10 seconden ingedrukt terwijl de switch aanstaat.
* **Resultaat:** Alle lampjes knipperen tegelijk. De switch is nu "schoon" (Default IP: 10.90.90.90 of DHCP).

---

### ✅ Checklist Resultaten:
- [ ] Fans draaien vrij en stil.
- [ ] Loopback op koperpoorten geeft link.
- [ ] SFP+ poorten 51 & 52 geven link met converters.
- [ ] Geen CRC-errors in de software.
