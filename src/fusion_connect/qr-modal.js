export class QRModal {
  constructor() {
    this.modal = null;
    this.qrCode = null;
    this.overlay = null;
    this.initializeModal();
  }

  initializeModal() {
    // Create modal elements
    this.overlay = document.createElement('div');
    this.modal = document.createElement('div');
    this.qrCode = document.createElement('div');
    const closeButton = document.createElement('button');
    
    // Add Tailwind classes
    this.overlay.className = 'fixed inset-0 bg-black/50 z-50';
    this.modal.className = 'fixed top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-white p-6 rounded-lg shadow-xl';
    this.qrCode.className = 'mb-4';
    closeButton.className = 'w-full bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded';

    // Build structure
    closeButton.textContent = 'Close';
    this.modal.appendChild(this.qrCode);
    this.modal.appendChild(closeButton);
    this.overlay.appendChild(this.modal);

    // Event listeners
    closeButton.addEventListener('click', () => this.hide());
    this.overlay.addEventListener('click', (e) => {
      if (e.target === this.overlay) this.hide();
    });
  }

  show(data, options = {}) {
    // Generate QR code
    const qr = qrcode(0, 'M');
    qr.addData(data);
    qr.make();
    
    // Clear previous QR code
    this.qrCode.innerHTML = qr.createSvgTag({
      cellSize: 8,
      margin: 4,
      ...options
    });

    // Add to DOM
    document.body.appendChild(this.overlay);
    document.body.classList.add('overflow-hidden');
  }

  hide() {
    if (this.overlay.parentNode) {
      document.body.removeChild(this.overlay);
      document.body.classList.remove('overflow-hidden');
    }
  }
} 