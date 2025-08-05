import { Component, OnInit, OnDestroy, Input, Output, EventEmitter } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Observable, Subject, BehaviorSubject } from 'rxjs';
import { takeUntil, debounceTime, distinctUntilChanged } from 'rxjs/operators';

// Interface definitions
interface User {
  id: number;
  username: string;
  email: string;
  active: boolean;
}

interface ListItem {
  id: number;
  name: string;
  description: string;
  active: boolean;
}

interface SelectOption {
  value: string;
  name: string;
}

@Component({
  selector: 'app-example',
  templateUrl: './example.component.html',
  styleUrls: ['./example.component.scss']
})
export class ExampleComponent implements OnInit, OnDestroy {
  // Properties
  title: string = 'Angular Development Example';
  appName: string = 'Kickstart Neovim';
  showContent: boolean = true;
  isLoading: boolean = false;
  counter: number = 0;
  currentDate: Date = new Date();
  price: number = 29.99;
  description: string = 'This is an example component showcasing Angular features with Neovim LSP support';

  // Form
  userForm: FormGroup;
  
  // Arrays and objects
  items: ListItem[] = [
    { id: 1, name: 'TypeScript Support', description: 'Full IntelliSense and type checking', active: true },
    { id: 2, name: 'Angular Language Server', description: 'Template and component analysis', active: false },
    { id: 3, name: 'Auto-formatting', description: 'Prettier integration', active: true },
    { id: 4, name: 'Linting', description: 'ESLint integration', active: true }
  ];

  options: SelectOption[] = [
    { value: 'option1', name: 'First Option' },
    { value: 'option2', name: 'Second Option' },
    { value: 'option3', name: 'Third Option' }
  ];

  selectedUser: User | null = null;
  selectedOption: string = '';

  // Observables and subjects
  private destroy$ = new Subject<void>();
  private searchSubject = new BehaviorSubject<string>('');
  public searchResults$: Observable<string[]>;

  // Input and Output properties
  @Input() config: any;
  @Output() dataChanged = new EventEmitter<any>();
  @Output() userSelected = new EventEmitter<User>();

  constructor(
    private formBuilder: FormBuilder
  ) {
    // Initialize form with validators
    this.userForm = this.formBuilder.group({
      username: ['', [Validators.required, Validators.minLength(3)]],
      email: ['', [Validators.required, Validators.email]]
    });

    // Set up search observable
    this.searchResults$ = this.searchSubject.pipe(
      debounceTime(300),
      distinctUntilChanged(),
      takeUntil(this.destroy$)
    ) as Observable<string[]>;
  }

  ngOnInit(): void {
    console.log('Component initialized');
    this.loadInitialData();
    this.setupFormValidation();
  }

  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
  }

  // Lifecycle and utility methods
  private loadInitialData(): void {
    // Simulate API call
    setTimeout(() => {
      this.selectedUser = {
        id: 1,
        username: 'developer',
        email: 'dev@example.com',
        active: true
      };
    }, 1000);
  }

  private setupFormValidation(): void {
    this.userForm.valueChanges
      .pipe(takeUntil(this.destroy$))
      .subscribe(value => {
        console.log('Form value changed:', value);
        this.dataChanged.emit(value);
      });
  }

  // Event handlers
  selectItem(item: ListItem, index: number): void {
    console.log(`Selected item: ${item.name} at index ${index}`);
    
    // Toggle active state
    this.items = this.items.map((listItem, i) => ({
      ...listItem,
      active: i === index ? !listItem.active : listItem.active
    }));
  }

  onSubmit(): void {
    if (this.userForm.valid) {
      console.log('Form submitted:', this.userForm.value);
      
      const formData = this.userForm.value;
      this.processFormData(formData);
    } else {
      console.log('Form is invalid');
      this.markFormGroupTouched();
    }
  }

  increment(): void {
    this.counter++;
  }

  reset(): void {
    this.counter = 0;
    this.userForm.reset();
  }

  async loadData(): Promise<void> {
    this.isLoading = true;
    
    try {
      // Simulate async operation
      await this.simulateApiCall();
      console.log('Data loaded successfully');
    } catch (error) {
      console.error('Error loading data:', error);
    } finally {
      this.isLoading = false;
    }
  }

  onUserSelected(user: User): void {
    this.selectedUser = user;
    this.userSelected.emit(user);
  }

  onUserDeleted(user: User): void {
    console.log('User deleted:', user);
    if (this.selectedUser?.id === user.id) {
      this.selectedUser = null;
    }
  }

  // TrackBy function for ngFor optimization
  trackByFn(index: number, item: ListItem): number {
    return item.id;
  }

  // Search functionality
  onSearch(term: string): void {
    this.searchSubject.next(term);
  }

  // Private helper methods
  private processFormData(data: any): void {
    // Process the form data
    console.log('Processing form data:', data);
    
    // Example of type-safe property access
    const username: string = data.username;
    const email: string = data.email;
    
    // Create user object
    const newUser: User = {
      id: Date.now(),
      username,
      email,
      active: true
    };
    
    console.log('Created user:', newUser);
  }

  private markFormGroupTouched(): void {
    Object.keys(this.userForm.controls).forEach(key => {
      const control = this.userForm.get(key);
      control?.markAsTouched();
    });
  }

  private async simulateApiCall(): Promise<any> {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve({ success: true, data: 'Mock data' });
      }, 2000);
    });
  }

  // Getter methods for template
  get isFormValid(): boolean {
    return this.userForm.valid;
  }

  get usernameControl() {
    return this.userForm.get('username');
  }

  get emailControl() {
    return this.userForm.get('email');
  }

  // Advanced TypeScript features
  genericMethod<T>(items: T[]): T | undefined {
    return items.length > 0 ? items[0] : undefined;
  }

  // Arrow function with type inference
  private readonly filterActiveItems = (items: ListItem[]): ListItem[] => {
    return items.filter(item => item.active);
  };

  // Conditional types example
  processData<T extends User | ListItem>(data: T): T extends User ? string : number {
    if ('username' in data) {
      return data.username as any;
    }
    return data.id as any;
  }
}